const UserModels = @import("../models/user.zig");
const pg = @import("pg");

pub fn insert(pool: *pg.Pool, user: UserModels.UserReq) !?i64 {
    const conn = try pool.acquire();
    defer conn.release();

    const query = "INSERT INTO users (name) VALUES ($1) RETURNING id";
    const result = try conn.query(query, .{user.name});
    defer result.deinit();

    if (try result.next()) |row| {
        return row.get(i32, 0);
    }
    return null;
}

pub fn get_by_id(pool: *pg.Pool, id: i32) !?UserModels.User {
    const conn = try pool.acquire();
    defer conn.release();

    const query = "select name, created_at from users where id = $1";
    var result = try conn.row(query, .{id}) orelse return null;
    defer result.deinit() catch {};
    return UserModels.User{ .id = null, .name = result.get([]u8, 0), .created_at = result.get(i64, 1) };
}
