(* DO NOT EDIT MANUALLY *)
(*  *)
(* generated by sqlgg 0.2.3-49-g30df037 on 2010-01-14T17:45Z *)

module Make (T : Sqlgg_traits.M) = struct

  let create_greeting db  =
    T.execute db "CREATE TABLE IF NOT EXISTS greeting (jid varchar, room varchar, msg varchar)" T.no_params 

  let create_index_gr_index db  =
    T.execute db "CREATE INDEX IF NOT EXISTS gr_index ON greeting (jid, room)" T.no_params 

  let check_greet db ~jid ~room =
    let get_row stmt =
      (T.get_column_Int stmt 0)
    in
    let set_params stmt =
      let p = T.start_params stmt 2 in
      T.set_param_Text p 0 jid;
      T.set_param_Text p 1 room;
      T.finish_params p
    in
    T.select1 db "SELECT 1 FROM greeting WHERE jid=@jid AND room=@room LIMIT 1" set_params get_row

  let add_greet db ~jid ~room ~msg =
    let set_params stmt =
      let p = T.start_params stmt 3 in
      T.set_param_Text p 0 jid;
      T.set_param_Text p 1 room;
      T.set_param_Text p 2 msg;
      T.finish_params p
    in
    T.execute db "INSERT INTO greeting (jid, room, msg) VALUES (@jid,@room,@msg)" set_params 

  let update_greet db ~msg ~jid ~room =
    let set_params stmt =
      let p = T.start_params stmt 3 in
      T.set_param_Text p 0 msg;
      T.set_param_Text p 1 jid;
      T.set_param_Text p 2 room;
      T.finish_params p
    in
    T.execute db "UPDATE greeting SET msg=@msg WHERE jid=@jid AND room=@room" set_params 

  let get_greet db ~jid ~room =
    let get_row stmt =
      (T.get_column_Text stmt 0)
    in
    let set_params stmt =
      let p = T.start_params stmt 2 in
      T.set_param_Text p 0 jid;
      T.set_param_Text p 1 room;
      T.finish_params p
    in
    T.select1 db "SELECT msg FROM greeting WHERE jid=@jid AND room=@room LIMIT 1" set_params get_row

  let create_users db  =
    T.execute db "CREATE TABLE IF NOT EXISTS users (jid varchar, room varchar, nick varchar, last integer, action varchar, reason varchar)" T.no_params 

  let create_index_users_index db  =
    T.execute db "CREATE INDEX IF NOT EXISTS users_index ON users (jid, room)" T.no_params 

  let create_index_users_nicks db  =
    T.execute db "CREATE INDEX IF NOT EXISTS users_nicks ON users (nick, room)" T.no_params 

  let check_user_by_nick db ~nick ~room =
    let get_row stmt =
      (T.get_column_Int stmt 0)
    in
    let set_params stmt =
      let p = T.start_params stmt 2 in
      T.set_param_Text p 0 nick;
      T.set_param_Text p 1 room;
      T.finish_params p
    in
    T.select1 db "SELECT 1 FROM users WHERE nick=@nick AND room=@room LIMIT 1" set_params get_row

  let update_user_by_nick db ~last ~action ~reason ~nick ~room =
    let set_params stmt =
      let p = T.start_params stmt 5 in
      T.set_param_Int p 0 last;
      T.set_param_Text p 1 action;
      T.set_param_Text p 2 reason;
      T.set_param_Text p 3 nick;
      T.set_param_Text p 4 room;
      T.finish_params p
    in
    T.execute db "UPDATE users SET last=@last, action=@action, reason=@reason WHERE nick=@nick AND room=@room" set_params 

  let add_user_by_nick db ~jid ~room ~nick ~last ~action ~reason =
    let set_params stmt =
      let p = T.start_params stmt 6 in
      T.set_param_Text p 0 jid;
      T.set_param_Text p 1 room;
      T.set_param_Text p 2 nick;
      T.set_param_Int p 3 last;
      T.set_param_Text p 4 action;
      T.set_param_Text p 5 reason;
      T.finish_params p
    in
    T.execute db "INSERT INTO users (jid, room, nick, last, action, reason) VALUES (@jid,@room,@nick,@last,@action,@reason)" set_params 

  let check_user_by_jid db ~jid ~room =
    let get_row stmt =
      (T.get_column_Int stmt 0)
    in
    let set_params stmt =
      let p = T.start_params stmt 2 in
      T.set_param_Text p 0 jid;
      T.set_param_Text p 1 room;
      T.finish_params p
    in
    T.select1 db "SELECT 1 FROM users WHERE jid=@jid AND room=@room LIMIT 1" set_params get_row

  let update_user_by_jid db ~last ~action ~reason ~jid ~room =
    let set_params stmt =
      let p = T.start_params stmt 5 in
      T.set_param_Int p 0 last;
      T.set_param_Text p 1 action;
      T.set_param_Text p 2 reason;
      T.set_param_Text p 3 jid;
      T.set_param_Text p 4 room;
      T.finish_params p
    in
    T.execute db "UPDATE users SET last=@last, action=@action, reason=@reason WHERE jid=@jid AND room=@room" set_params 

  let add_user_by_jid db ~jid ~room ~nick ~last ~action ~reason =
    let set_params stmt =
      let p = T.start_params stmt 6 in
      T.set_param_Text p 0 jid;
      T.set_param_Text p 1 room;
      T.set_param_Text p 2 nick;
      T.set_param_Int p 3 last;
      T.set_param_Text p 4 action;
      T.set_param_Text p 5 reason;
      T.finish_params p
    in
    T.execute db "INSERT INTO users (jid, room, nick, last, action, reason) VALUES (@jid,@room,@nick,@last,@action,@reason)" set_params 

  let seen_by_nick db ~nick ~room =
    let get_row stmt =
      (T.get_column_Text stmt 0), (T.get_column_Int stmt 1), (T.get_column_Text stmt 2), (T.get_column_Text stmt 3)
    in
    let set_params stmt =
      let p = T.start_params stmt 2 in
      T.set_param_Text p 0 nick;
      T.set_param_Text p 1 room;
      T.finish_params p
    in
    T.select1 db "SELECT jid, last, action, reason FROM users WHERE nick=@nick AND room=@room ORDER BY last DESC LIMIT 1" set_params get_row

  module Fold = struct
    let create_greeting db  =
      T.execute db "CREATE TABLE IF NOT EXISTS greeting (jid varchar, room varchar, msg varchar)" T.no_params 

    let create_index_gr_index db  =
      T.execute db "CREATE INDEX IF NOT EXISTS gr_index ON greeting (jid, room)" T.no_params 

    let check_greet db ~jid ~room =
      let get_row stmt =
        (T.get_column_Int stmt 0)
      in
      let set_params stmt =
        let p = T.start_params stmt 2 in
        T.set_param_Text p 0 jid;
        T.set_param_Text p 1 room;
        T.finish_params p
      in
      T.select1 db "SELECT 1 FROM greeting WHERE jid=@jid AND room=@room LIMIT 1" set_params get_row

    let add_greet db ~jid ~room ~msg =
      let set_params stmt =
        let p = T.start_params stmt 3 in
        T.set_param_Text p 0 jid;
        T.set_param_Text p 1 room;
        T.set_param_Text p 2 msg;
        T.finish_params p
      in
      T.execute db "INSERT INTO greeting (jid, room, msg) VALUES (@jid,@room,@msg)" set_params 

    let update_greet db ~msg ~jid ~room =
      let set_params stmt =
        let p = T.start_params stmt 3 in
        T.set_param_Text p 0 msg;
        T.set_param_Text p 1 jid;
        T.set_param_Text p 2 room;
        T.finish_params p
      in
      T.execute db "UPDATE greeting SET msg=@msg WHERE jid=@jid AND room=@room" set_params 

    let get_greet db ~jid ~room =
      let get_row stmt =
        (T.get_column_Text stmt 0)
      in
      let set_params stmt =
        let p = T.start_params stmt 2 in
        T.set_param_Text p 0 jid;
        T.set_param_Text p 1 room;
        T.finish_params p
      in
      T.select1 db "SELECT msg FROM greeting WHERE jid=@jid AND room=@room LIMIT 1" set_params get_row

    let create_users db  =
      T.execute db "CREATE TABLE IF NOT EXISTS users (jid varchar, room varchar, nick varchar, last integer, action varchar, reason varchar)" T.no_params 

    let create_index_users_index db  =
      T.execute db "CREATE INDEX IF NOT EXISTS users_index ON users (jid, room)" T.no_params 

    let create_index_users_nicks db  =
      T.execute db "CREATE INDEX IF NOT EXISTS users_nicks ON users (nick, room)" T.no_params 

    let check_user_by_nick db ~nick ~room =
      let get_row stmt =
        (T.get_column_Int stmt 0)
      in
      let set_params stmt =
        let p = T.start_params stmt 2 in
        T.set_param_Text p 0 nick;
        T.set_param_Text p 1 room;
        T.finish_params p
      in
      T.select1 db "SELECT 1 FROM users WHERE nick=@nick AND room=@room LIMIT 1" set_params get_row

    let update_user_by_nick db ~last ~action ~reason ~nick ~room =
      let set_params stmt =
        let p = T.start_params stmt 5 in
        T.set_param_Int p 0 last;
        T.set_param_Text p 1 action;
        T.set_param_Text p 2 reason;
        T.set_param_Text p 3 nick;
        T.set_param_Text p 4 room;
        T.finish_params p
      in
      T.execute db "UPDATE users SET last=@last, action=@action, reason=@reason WHERE nick=@nick AND room=@room" set_params 

    let add_user_by_nick db ~jid ~room ~nick ~last ~action ~reason =
      let set_params stmt =
        let p = T.start_params stmt 6 in
        T.set_param_Text p 0 jid;
        T.set_param_Text p 1 room;
        T.set_param_Text p 2 nick;
        T.set_param_Int p 3 last;
        T.set_param_Text p 4 action;
        T.set_param_Text p 5 reason;
        T.finish_params p
      in
      T.execute db "INSERT INTO users (jid, room, nick, last, action, reason) VALUES (@jid,@room,@nick,@last,@action,@reason)" set_params 

    let check_user_by_jid db ~jid ~room =
      let get_row stmt =
        (T.get_column_Int stmt 0)
      in
      let set_params stmt =
        let p = T.start_params stmt 2 in
        T.set_param_Text p 0 jid;
        T.set_param_Text p 1 room;
        T.finish_params p
      in
      T.select1 db "SELECT 1 FROM users WHERE jid=@jid AND room=@room LIMIT 1" set_params get_row

    let update_user_by_jid db ~last ~action ~reason ~jid ~room =
      let set_params stmt =
        let p = T.start_params stmt 5 in
        T.set_param_Int p 0 last;
        T.set_param_Text p 1 action;
        T.set_param_Text p 2 reason;
        T.set_param_Text p 3 jid;
        T.set_param_Text p 4 room;
        T.finish_params p
      in
      T.execute db "UPDATE users SET last=@last, action=@action, reason=@reason WHERE jid=@jid AND room=@room" set_params 

    let add_user_by_jid db ~jid ~room ~nick ~last ~action ~reason =
      let set_params stmt =
        let p = T.start_params stmt 6 in
        T.set_param_Text p 0 jid;
        T.set_param_Text p 1 room;
        T.set_param_Text p 2 nick;
        T.set_param_Int p 3 last;
        T.set_param_Text p 4 action;
        T.set_param_Text p 5 reason;
        T.finish_params p
      in
      T.execute db "INSERT INTO users (jid, room, nick, last, action, reason) VALUES (@jid,@room,@nick,@last,@action,@reason)" set_params 

    let seen_by_nick db ~nick ~room =
      let get_row stmt =
        (T.get_column_Text stmt 0), (T.get_column_Int stmt 1), (T.get_column_Text stmt 2), (T.get_column_Text stmt 3)
      in
      let set_params stmt =
        let p = T.start_params stmt 2 in
        T.set_param_Text p 0 nick;
        T.set_param_Text p 1 room;
        T.finish_params p
      in
      T.select1 db "SELECT jid, last, action, reason FROM users WHERE nick=@nick AND room=@room ORDER BY last DESC LIMIT 1" set_params get_row

  end (* module Fold *)
end (* module Make *)