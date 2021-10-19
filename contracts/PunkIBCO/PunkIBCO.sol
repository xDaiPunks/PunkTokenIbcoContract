/**
 *  _______                    __            ______ _______   ______   ______
 * |       \                  |  \          |      \       \ /      \ /      \
 * | ▓▓▓▓▓▓▓\__    __ _______ | ▓▓   __      \▓▓▓▓▓▓ ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\
 * | ▓▓__/ ▓▓  \  |  \       \| ▓▓  /  \      | ▓▓ | ▓▓__/ ▓▓ ▓▓   \▓▓ ▓▓  | ▓▓
 * | ▓▓    ▓▓ ▓▓  | ▓▓ ▓▓▓▓▓▓▓\ ▓▓_/  ▓▓      | ▓▓ | ▓▓    ▓▓ ▓▓     | ▓▓  | ▓▓
 * | ▓▓▓▓▓▓▓| ▓▓  | ▓▓ ▓▓  | ▓▓ ▓▓   ▓▓       | ▓▓ | ▓▓▓▓▓▓▓\ ▓▓   __| ▓▓  | ▓▓
 * | ▓▓     | ▓▓__/ ▓▓ ▓▓  | ▓▓ ▓▓▓▓▓▓\      _| ▓▓_| ▓▓__/ ▓▓ ▓▓__/  \ ▓▓__/ ▓▓
 * | ▓▓      \▓▓    ▓▓ ▓▓  | ▓▓ ▓▓  \▓▓\    |   ▓▓ \ ▓▓    ▓▓\▓▓    ▓▓\▓▓    ▓▓
 *  \▓▓       \▓▓▓▓▓▓ \▓▓   \▓▓\▓▓   \▓▓     \▓▓▓▓▓▓\▓▓▓▓▓▓▓  \▓▓▓▓▓▓  \▓▓▓▓▓▓
 *
 * $PNK IBCO
 *
 */

pragma solidity 0.8.0;

/**
 * SPDX-License-Identifier: GPL-3.0-or-later
 * xDaiPunks
 * Copyright (C) 2021 xDaiPunks
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title PunkIBCO
 * @dev Contract for the Initial Bond Curve Offering.
 * The IBCO is based is a pro rata devision of the contribution and the fixed distribution of $PNK tokens
 */
contract PunkIBCO is Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    event Received(address indexed account, uint256 amount);
    event Claimed(
        address indexed account,
        uint256 userShare,
        uint256 punkAmount
    );

    uint256 public endTime;
    uint256 public startTime;

    uint256 public totalRevenue = 0;
    uint256 public minimalRevenue = 0;

    uint256 public constant DISTRIBUTION = 50_000_000e18;

    mapping(address => uint256) public senderContribution;

    IERC20 public immutable Punk;

    /**
     * @dev Sets the values for {startTime}, {endTime} and {Punk} token.
     *
     * @param _duration: number of seconds the IBCO should last
     * @param _startTime: unix time of the start of the IBCO
     * @param _Punk: contract address of the Punk ERC20 token
     */
    constructor(
        uint256 _duration,
        uint256 _startTime,
        IERC20 _Punk
    ) {
        Punk = _Punk;

        startTime = _startTime;
        endTime = _duration + _startTime;
    }

    /**
     * @dev Stores sent amount in sendContribution mapping.
     *
     * Emits a {Received} event.
     */

    receive() external payable {
        require(
            startTime <= block.timestamp,
            "The Initial Bond Curve Offering has not started yet"
        );
        require(
            block.timestamp <= endTime,
            "The Initial Bond Curve Offering has ended"
        );

        totalRevenue += msg.value;
        senderContribution[msg.sender] += msg.value;

        emit Received(msg.sender, msg.value);
    }

    /**
     * @dev Transfers tokens pro rata to sendContribution mapping.
     * If minimalRevenue is not met, the senderContribution will be returned
     *
     * Emits a {Claimed} event.
     */

    function claim() external nonReentrant {
        require(block.timestamp > endTime);
        require(senderContribution[msg.sender] > 0);

        uint256 userShare = senderContribution[msg.sender];

        senderContribution[msg.sender] = 0;

        if (totalRevenue >= minimalRevenue) {
            uint256 punkAmount = DISTRIBUTION.mul(userShare).div(totalRevenue);
            Punk.safeTransfer(msg.sender, punkAmount);

            emit Claimed(msg.sender, userShare, punkAmount);
        } else {
            payable(msg.sender).transfer(userShare);

            emit Claimed(msg.sender, userShare, 0);
        }
    }

    /**
     * @dev Withdraws sent funds to contract owner when minimal revenue is met.
     */

    function withdraw() external onlyOwner {
        require(
            totalRevenue >= minimalRevenue,
            "The minimal revenue has not been reached"
        );

        payable(owner()).transfer(address(this).balance);
    }

    /**
     * @dev Updates {startTime} and {endTime} of IBCO if contract owner
     *
     * @param _duration: number of seconds the IBCO should last
     * @param _startTime: unix time of the start of the IBCO
     */

    function updateFundraisingTime(uint256 _duration, uint256 _startTime)
        external
        onlyOwner
    {
        startTime = _startTime;
        endTime = _duration + _startTime;
    }
}
