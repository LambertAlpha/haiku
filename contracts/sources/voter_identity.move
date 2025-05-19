module haiku::voter_identity {
    // 错误码
    const E_INVALID_PROOF: u64 = 1;
    const E_ALREADY_REGISTERED: u64 = 2;
    // const E_NOT_REGISTERED: u64 = 3;

    public struct IdentityRegistry has key {
        id: object::UID,
        registered_identities: vector<address>,
        identity_proofs: vector<vector<u8>>
    }

    public struct IdentityToken has key {
        id: object::UID,
        owner: address,
        proof: vector<u8>
    }

    // 初始化身份注册表
    public fun initialize(ctx: &mut TxContext) {
        let registry = IdentityRegistry {
            id: object::new(ctx),
            registered_identities: vector::empty(),
            identity_proofs: vector::empty()
        };
        transfer::share_object(registry);
    }

    // 注册新身份
    public fun register_identity(
        registry: &mut IdentityRegistry,
        zkp: vector<u8>,
        ctx: &mut TxContext
    ) {
        let sender = sui::tx_context::sender(ctx);
        
        // 确保未重复注册
        assert!(!vector::contains(&registry.registered_identities, &sender), E_ALREADY_REGISTERED);
        
        // 验证零知识证明
        assert!(verify_identity_proof(&zkp), E_INVALID_PROOF);
        
        // 记录身份
        vector::push_back(&mut registry.registered_identities, sender);
        vector::push_back(&mut registry.identity_proofs, zkp);
        
        // 创建身份令牌
        let token = IdentityToken {
            id: object::new(ctx),
            owner: sender,
            proof: zkp
        };
        transfer::transfer(token, sender);
    }

    // 验证身份
    public fun verify_identity(registry: &IdentityRegistry, address: address): bool {
        vector::contains(&registry.registered_identities, &address)
    }

    // 内部函数：验证零知识证明
    fun verify_identity_proof(_proof: &vector<u8>): bool {
        // 实现ZKP验证逻辑
        true // 简化示例
    }
}