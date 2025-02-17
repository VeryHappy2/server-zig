const UserModel = @import("../models/user.zig");
const pg = @import("pg");
const httpz = @import("httpz");
const repository = @import("../repositories/user_rep.zig");
const App = @import("../models/app.zig").App;
const by_id_req = @import("../models/by_id_req.zig");
const std = @import("std");

pub fn insert(app: *App, req: *httpz.Request, res: *httpz.Response) anyerror!void {
    if (try req.json(UserModel.UserReq)) |user| {
        _ = (try repository.insert(app.db, user)) orelse {
            res.status = 400;
            res.body = "Insert failed";
            return;
        };
        res.status = 200;
        res.body = "User was created";
    } else {
        res.status = 400;
        res.body = "User was not created";
    }
}

pub fn get_by_id(app: *App, req: *httpz.Request, res: *httpz.Response) !void {
    if (try req.json(by_id_req.ByIdReq)) |id| {
        const name = repository.get_by_id(app.db, id.id) catch {
            res.status = 500;
            res.body = "Database error";
            return;
        };

        if (name == null) {
            res.status = 404;
            res.body = "Not found";
            return;
        }

        res.status = 200;
        try res.json(name, .{});
    } else {
        res.status = 400;
        res.body = "You need to type an id";
    }
}
