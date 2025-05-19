// the main part of the voting system, including the function to calculate the result of the voting

module haiku::voting_system {
    use sui::dynamic_field;
    use sui::clock::Clock;
    
    // 错误码
    const E_NOT_AUTHORIZED: u64 = 0;
    const E_VOTING_NOT_STARTED: u64 = 2;
    const E_VOTING_ENDED: u64 = 3;
    const E_ALREADY_VOTED: u64 = 4;
    const E_INVALID_PROOF: u64 = 5;

    // 投票状态
    const STATUS_NOT_STARTED: u8 = 0;

    public struct VotingSystem has key {
        id: object::UID,                    // 投票系統的唯一標識符
        admin: address,                     // 管理員地址,具有管理權限
        status: u8,                         // 投票系統當前狀態(0:未開始)
        start_time: u64,                    // 投票開始時間戳
        end_time: u64,                      // 投票結束時間戳
        total_options: u8,                  // 可選項總數
        voter_count: u64,                   // 已投票人數統計
        ballot_box: object::UID,            // 存儲選票的動態字段容器
    }

    public struct Ballot has key, store {
        id: object::UID,
        encrypted_vote: vector<u8>,  // 同态加密的投票数据
        proof: vector<u8>,           // ZKP证明
        timestamp: u64,
        voter: address
    }

    public struct VoterRegistry has key {
        id: object::UID,
        commitment: vector<u8>,      // 选民身份承诺
        registered_voters: vector<address>
    }

    public struct EncryptedTally has key {
        id: object::UID,
        aggregated_votes: vector<u8>,
        proof_of_sum: vector<u8>
    }

    public struct HomomorphicVote has store {
        cipher: vector<u8>,
        rand_seed: vector<u8>
    }

    // 初始化投票系统
    public fun initialize_voting(
        total_options: u8,
        start_time: u64,
        end_time: u64,
        ctx: &mut TxContext
    ) {
        let sender = sui::tx_context::sender(ctx);
        
        let ballot_box = object::new(ctx);
        
        let voting_system = VotingSystem {
            id: object::new(ctx),
            admin: sender,
            status: STATUS_NOT_STARTED,
            start_time,
            end_time,
            total_options,
            voter_count: 0,
            ballot_box,
        };

        let voter_registry = VoterRegistry {
            id: object::new(ctx),
            commitment: vector::empty(),
            registered_voters: vector::empty()
        };

        transfer::share_object(voting_system);
        transfer::share_object(voter_registry);
    }

    // 注册选民
    public fun register_voter(
        voting_system: &mut VotingSystem,
        registry: &mut VoterRegistry,
        identity_proof: vector<u8>,
        ctx: &mut TxContext
    ) {
        let sender = sui::tx_context::sender(ctx);
        
        // 验证身份证明
        assert!(verify_identity_proof(&identity_proof), E_INVALID_PROOF);
        
        // 确保选民未注册
        assert!(!vector::contains(&registry.registered_voters, &sender), E_ALREADY_VOTED);
        
        // 记录选民
        vector::push_back(&mut registry.registered_voters, sender);
        
        // 更新选民计数
        voting_system.voter_count = voting_system.voter_count + 1;
    }

    // 投票
    public fun cast_vote(
        voting_system: &mut VotingSystem,
        encrypted_vote: vector<u8>,
        vote_proof: vector<u8>,
        clock: &Clock,
        ctx: &mut TxContext
    ) {
        let sender = sui::tx_context::sender(ctx);
        let current_time = sui::clock::timestamp_ms(clock);
        
        // 检查投票时间
        assert!(current_time >= voting_system.start_time, E_VOTING_NOT_STARTED);
        assert!(current_time <= voting_system.end_time, E_VOTING_ENDED);
        
        // 验证投票证明
        assert!(verify_vote_proof(&vote_proof), E_INVALID_PROOF);
        
        // 创建加密选票
        let ballot = Ballot {
            id: object::new(ctx),
            encrypted_vote,
            proof: vote_proof,
            timestamp: current_time,
            voter: sender
        };
        
        // 存储选票
        dynamic_field::add(&mut voting_system.ballot_box, sender, ballot);
    }

    // 计票
    public fun aggregate_votes(
        voting_system: &mut VotingSystem,
        ctx: &mut TxContext
    ): EncryptedTally {
        let sender = sui::tx_context::sender(ctx);
        assert!(sender == voting_system.admin, E_NOT_AUTHORIZED);
        
        // 聚合所有加密选票
        let aggregated = vector::empty();
        // 这里需要遍历所有选票并进行同态加法
        // 实际实现中可能需要在链下完成复杂计算
        
        EncryptedTally {
            id: object::new(ctx),
            aggregated_votes: aggregated,
            proof_of_sum: vector::empty() // 需要生成正确性证明
        }
    }

    // 验证计票结果
    public fun verify_tally(
        tally: &EncryptedTally
    ): bool {
        // 验证计票证明
        verify_tally_proof(&tally.proof_of_sum)
    }

    // 内部辅助函数
    fun verify_identity_proof(proof: &vector<u8>): bool {
        // 实现ZKP验证逻辑
        true // 简化示例
    }

    fun verify_vote_proof(proof: &vector<u8>): bool {
        // 实现投票证明验证逻辑
        true // 简化示例
    }

    fun verify_tally_proof(proof: &vector<u8>): bool {
        // 实现计票证明验证逻辑
        true // 简化示例
    }

    // 获取投票系统状态
    public fun get_status(voting_system: &VotingSystem): u8 {
        voting_system.status
    }

    // 获取投票人数
    public fun get_voter_count(voting_system: &VotingSystem): u64 {
        voting_system.voter_count
    }

    #[test_only]
    public fun test_initialize(ctx: &mut TxContext) {
        haiku::voting_system::initialize_voting(1,1,1,ctx);
    }
}