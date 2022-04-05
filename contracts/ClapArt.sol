// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract ClapArt is Ownable, ERC20, Pausable {

    uint256 constant MAX = 888888888 ether;
    address public OWNER_WALLET;
    mapping(address => bool) internal _LockList;

    event LockAddress(address indexed account);
    event UnLockAddress(address indexed account);
    event BurnToken(address indexed account, uint256 amount);

    constructor (address _admin) ERC20("ClapArt", "CLP") {
        require(_admin != address(0x0), "Constructor: Ownerwallet can not be a zero");
        OWNER_WALLET = _admin;
        // mint total supply to admin walelt
        _mint(OWNER_WALLET, MAX);
        transferOwnership(OWNER_WALLET);
    }

    function burn(uint256 _amount) external onlyOwner {
        _burn(_msgSender(), _amount);
        emit BurnToken(_msgSender(), _amount);
    }

    /// @dev Add an address from LockAddress
    /// @return bool
    function lockAddress(address account) external onlyOwner returns (bool) {
        _LockList[account] = true;
        emit LockAddress(account);
        return true;
    }

    /// @dev Removes an address from LockAddress
    /// @return bool
    function unLockAddress(address account) external onlyOwner returns (bool) {
        delete _LockList[account];
        emit UnLockAddress(account);
        return true;
    }

    /// @dev Checks if an address is in LockAddress
    /// @return bool
    function LockedAddressList(address account) external view virtual returns (bool) {
        return _LockList[account];
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
    internal
    whenNotPaused
    override(ERC20)
    {
        require(!_LockList[from], "Token transfer is not allowed until the lock is released.");
        super._beforeTokenTransfer(from, to, amount);
    }
}
