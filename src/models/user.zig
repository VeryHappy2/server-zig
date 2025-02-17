pub const User = struct {
    name: []const u8,
    id: ?i32,
    created_at: i64,
};

pub const UserReq = struct { name: []const u8 };
