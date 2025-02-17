const pg = @import("pg");

pub fn init_tables(pool: *pg.Pool) !void {
    var conn = try pool.acquire();
    defer conn.release();
    const sql =
        \\ CREATE TABLE IF NOT EXISTS users (
        \\     id SERIAL PRIMARY KEY,
        \\     name TEXT NOT NULL,
        \\     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        \\ );
    ;
    _ = try conn.exec(sql, .{});
}
