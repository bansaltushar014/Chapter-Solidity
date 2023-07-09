pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
  struct Role {
    mapping (address => bool) bearer;
  }

  /**
   * @dev give an account access to this role
   */
  function add(Role storage role, address account) internal {
    require(account != address(0));
    require(!has(role, account));

    role.bearer[account] = true;
  }

  /**
   * @dev remove an account's access to this role
   */
  function remove(Role storage role, address account) internal {
    require(account != address(0));
    require(has(role, account));

    role.bearer[account] = false;
  }

  /**
   * @dev check if an account has this role
   * @return bool
   */
  function has(Role storage role, address account)
    internal
    view
    returns (bool)
  {
    require(account != address(0));
    return role.bearer[account];
  }
}

contract MyToken is ERC20 {
    using Roles for Roles.Role;

    Roles.Role private _minters;
    Roles.Role private _burners;

    constructor(address[] memory minters, address[] memory burners)
        ERC20("MyToken", "MTKN")
        public
    {
        for (uint256 i = 0; i < minters.length; ++i) {
            _minters.add(minters[i]);
        }

        for (uint256 i = 0; i < burners.length; ++i) {
            _burners.add(burners[i]);
        }
    }

    function mint(address to, uint256 amount) public {
        // Only minters can mint
        require(_minters.has(msg.sender), "DOES_NOT_HAVE_MINTER_ROLE");

        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public {
        // Only burners can burn
        require(_burners.has(msg.sender), "DOES_NOT_HAVE_BURNER_ROLE");

       _burn(from, amount);
    }
}
