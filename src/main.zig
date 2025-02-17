const std = @import("std");
const pg = @import("pg");
const httpz = @import("httpz");
const table = @import("db/init_tables.zig");
const user_handler = @import("handlers/user_handler.zig");
const App = @import("models/app.zig").App;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var pool = try pg.Pool.init(allocator, .{
        .size = 5,
        .connect = .{
            .port = 5435,
        },
        .auth = .{ .database = "postgres", .username = "postgres", .password = "postgres" },
    });
    defer pool.deinit();
    var app = App{
        .db = pool,
    };
    try table.init_tables(pool);

    var server = try httpz.Server(*App).init(allocator, .{ .port = 5882 }, &app);
    std.debug.print("Server was started", .{});
    defer {
        server.stop();
        server.deinit();
    }

    // try table.init_tables(pool);
    var router = server.router(.{});
    router.post("/user/create", user_handler.insert, .{});
    router.post("/user/getbyid", user_handler.get_by_id, .{ .data = pool });
    try server.listen();
}
