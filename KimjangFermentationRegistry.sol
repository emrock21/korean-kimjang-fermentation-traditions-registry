// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

contract KimjangFermentationRegistry {

    struct KimjangTradition {
        string kimchiType;          // baechu, dongchimi, bossam, etc.
        string region;              // Jeolla, Gyeongsang, Hwanghae
        string ingredients;         // napa cabbage, radish, gochugaru, jeotgal
        string techniques;          // salting, brining, seasoning, fermentation
        string seasonalContext;     // winter kimjang, summer varieties
        string culturalContext;     // communal preparation, family roles
        string uniqueness;          // regional identity, fermentation profile
        address creator;
        uint256 likes;
        uint256 dislikes;
        uint256 createdAt;
    }

    struct KimjangInput {
        string kimchiType;
        string region;
        string ingredients;
        string techniques;
        string seasonalContext;
        string culturalContext;
        string uniqueness;
    }

    KimjangTradition[] public traditions;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event KimjangRecorded(uint256 indexed id, string kimchiType, address indexed creator);
    event KimjangVoted(uint256 indexed id, bool like, uint256 likes, uint256 dislikes);

    constructor() {
        traditions.push(
            KimjangTradition({
                kimchiType: "Example (replace manually)",
                region: "example",
                ingredients: "example",
                techniques: "example",
                seasonalContext: "example",
                culturalContext: "example",
                uniqueness: "example",
                creator: address(0),
                likes: 0,
                dislikes: 0,
                createdAt: block.timestamp
            })
        );
    }

    function recordKimjang(KimjangInput calldata k) external {
        traditions.push(
            KimjangTradition({
                kimchiType: k.kimchiType,
                region: k.region,
                ingredients: k.ingredients,
                techniques: k.techniques,
                seasonalContext: k.seasonalContext,
                culturalContext: k.culturalContext,
                uniqueness: k.uniqueness,
                creator: msg.sender,
                likes: 0,
                dislikes: 0,
                createdAt: block.timestamp
            })
        );

        emit KimjangRecorded(traditions.length - 1, k.kimchiType, msg.sender);
    }

    function voteKimjang(uint256 id, bool like) external {
        require(id < traditions.length, "Invalid ID");
        require(!hasVoted[id][msg.sender], "Already voted");

        hasVoted[id][msg.sender] = true;
        KimjangTradition storage k = traditions[id];

        if (like) k.likes++;
        else k.dislikes++;

        emit KimjangVoted(id, like, k.likes, k.dislikes);
    }

    function totalKimjang() external view returns (uint256) {
        return traditions.length;
    }
}
