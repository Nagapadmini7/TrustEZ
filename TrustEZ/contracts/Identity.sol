// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IdentityVerification {
    struct Identity {
        string name;
        string country;
        bool isVerified;
    }

    address private owner;
    mapping(address => bool) private verifiers;
    mapping(address => Identity) private identities;

    event VerificationRequest(
        address indexed user,
        string name,
        string country
    );
    event VerificationApproved(address indexed user, address indexed verifier);

    constructor() {
        owner = msg.sender; // The sender is the owner
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can add a verifier.");
        _;
    }

    modifier onlyVerifier() {
        require(
            verifiers[msg.sender] == true,
            "Only a verifier can approve verification."
        );
        _;
    }

    function addVerifier(address _verifier) public onlyOwner {
        verifiers[_verifier] = true;
    }

    function requestVerification(
        string memory _name,
        string memory _country
    ) public {
        require(bytes(_name).length > 0, "Name is required.");
        require(bytes(_country).length > 0, "Country is required.");

        Identity storage user = identities[msg.sender];
        user.name = _name;
        user.country = _country;
        user.isVerified = false;
        emit VerificationRequest(msg.sender, _name, _country);
    }

    function approveVerification(address _user) public onlyVerifier {
        Identity storage user = identities[_user];
        require(user.isVerified == false, "User is already verified.");
        user.isVerified = true;
        emit VerificationApproved(_user, msg.sender);
    }

    function isUserVerified(address _user) public view returns (bool) {
        return identities[_user].isVerified;
    }

    function getIdentity(
        address _user
    ) public view returns (string memory, string memory, bool) {
        Identity memory user = identities[_user];
        return (user.name, user.country, user.isVerified);
    }
}
