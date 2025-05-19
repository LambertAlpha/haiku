module haiku::voter_identit {

    // 错误码
    const E_NOT_AUTHORIZED: u64 = 1;
    const E_ROLE_EXISTS: u64 = 2;

    // 角色定义
    // const ROLE_ADMIN: u8 = 1;
    // const ROLE_VOTER: u8 = 2;

    public struct AccessControl has key {
        id: object::UID,
        admin: address,
        roles: vector<Role>
    }

    public struct Role has store {
        role_type: u8,
        account: address
    }

    // 初始化访问控制
    public fun initialize(ctx: &mut TxContext) {
        let sender = sui::tx_context::sender(ctx);
        let access_control = AccessControl {
            id: object::new(ctx),
            admin: sender,
            roles: vector::empty()
        };
        transfer::share_object(access_control);
    }

    // 授予角色
    public fun grant_role(
        access_control: &mut AccessControl,
        role_type: u8,
        account: address,
        ctx: &mut TxContext
    ) {
        let sender = sui::tx_context::sender(ctx);
        assert!(sender == access_control.admin, E_NOT_AUTHORIZED);
        // 检查角色是否已存在
        assert!(!has_role(access_control, role_type, account), E_ROLE_EXISTS);
        let role = Role {
            role_type,
            account
        };
        vector::push_back(&mut access_control.roles, role);
    }

    // 检查角色
    public fun has_role(access_control: &AccessControl, role_type: u8, account: address): bool {
        let mut i = 0;
        let len = vector::length(&access_control.roles);
        while (i < len) {
            let role = vector::borrow(&access_control.roles, i);
            if (role.role_type == role_type && role.account == account) {
                return true
            };
            i = i + 1;
        };
        false
    }

    // 检查管理员权限
    public fun is_admin(access_control: &AccessControl, account: address): bool {
        account == access_control.admin
    }
}
