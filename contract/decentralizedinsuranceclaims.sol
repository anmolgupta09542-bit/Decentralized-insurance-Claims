// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Decentralized Insurance Claims
 * @dev A simple decentralized contract allowing users to submit and track insurance claims.
 */
contract Project {
    enum ClaimStatus { Pending, Approved, Rejected }

    struct Claim {
        address claimant;
        string description;
        uint256 amount;
        ClaimStatus status;
    }

    address public insurer;
    uint256 public claimCounter;

    mapping(uint256 => Claim) public claims;

    event ClaimSubmitted(uint256 claimId, address claimant, uint256 amount);
    event ClaimApproved(uint256 claimId);
    event ClaimRejected(uint256 claimId);

    modifier onlyInsurer() {
        require(msg.sender == insurer, "Only insurer can perform this action");
        _;
    }

    constructor() {
        insurer = msg.sender;
    }

    /**
     * @dev Submit a new claim
     * @param _description Description of the claim
     * @param _amount Claim amount
     */
    function submitClaim(string calldata _description, uint256 _amount) external {
        claimCounter++;

        claims[claimCounter] = Claim({
            claimant: msg.sender,
            description: _description,
            amount: _amount,
            status: ClaimStatus.Pending
        });

        emit ClaimSubmitted(claimCounter, msg.sender, _amount);
    }

    /**
     * @dev Approve a pending claim
     * @param _claimId ID of the claim to approve
     */
    function approveClaim(uint256 _claimId) external onlyInsurer {
        Claim storage claim = claims[_claimId];
        require(claim.status == ClaimStatus.Pending, "Claim already processed");

        claim.status = ClaimStatus.Approved;

        emit ClaimApproved(_claimId);
    }

    /**
     * @dev Reject a pending claim
     * @param _claimId ID of the claim to reject
     */
    function rejectClaim(uint256 _claimId) external onlyInsurer {
        Claim storage claim = claims[_claimId];
        require(claim.status == ClaimStatus.Pending, "Claim already processed");

        claim.status = ClaimStatus.Rejected;

        emit ClaimRejected(_claimId);
    }
}
