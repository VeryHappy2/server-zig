const pg = @import("pg");

pub const App = struct {
    db: *pg.Pool,
};
