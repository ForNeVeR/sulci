(*
 * (c) 2004-2012 Anastasia Gornostaeva
*)

open Common

let ext = ".htbl"

module LangMap = Map.Make(String)

type langtime_t = {
  expand_time: string -> int -> int -> int -> int -> int -> int -> string;
  float_seconds: string -> float -> string
}

module LangTime = Map.Make(String)

let langmsgs : (string, string) Hashtbl.t LangMap.t ref = ref LangMap.empty
let langtime : langtime_t LangTime.t ref = ref LangTime.empty

let langdir = ref ""
let deflang = ref "ru"

let load_htbl cfg lang =
  let htbl = Marshal.from_channel 
    (open_in_bin (Filename.concat !langdir (lang ^ ext))) in
    langmsgs := LangMap.add lang htbl !langmsgs
      
let find_htbl lang =
  try
    LangMap.find lang !langmsgs
  with Not_found ->
    try
      let htbl =  Marshal.from_channel 
        (open_in_bin (Filename.concat !langdir (lang ^ ext))) in
        langmsgs := LangMap.add lang htbl !langmsgs;
        htbl
    with _ ->
      LangMap.find !deflang !langmsgs
        
let process str args =
  let rec aux_subst acc part = function
    | [] -> List.rev (part :: acc)
    | arges ->
        try
          let mark = String.index part '%' in
            if mark+1 < String.length part then
              match part.[mark+1] with
                | '1'..'9' as d -> (
                    let n = Char.code d - Char.code '0' -1 in
                      if mark+2 < String.length part then
                        match part.[mark+2] with
                          | 's' ->
                              aux_subst (List.nth args n ::
                                String.sub part 0 mark :: acc)
                                (string_after part (mark+3)) arges
                          | _ ->
                              aux_subst (String.sub part 0 (mark+3) :: acc)
                                (string_after part (mark+3)) arges
                      else
                        List.rev (part :: acc)
                  )
                | 's' ->
                    aux_subst (List.hd arges :: String.sub part 0 mark :: acc)
                      (string_after part (mark+2)) (List.tl arges)
                | _ ->
                    aux_subst (String.sub part 0 (mark+2) :: acc)
                      (string_after part (mark+2)) arges
            else
              List.rev (part :: acc)
        with Not_found ->
          List.rev (part :: acc)
  in
  let res = aux_subst []  str args in
    String.concat "" res
      
let get_msg lang msgid args =
  try
    let htbl = find_htbl lang in
    let str =
      try Hashtbl.find htbl msgid with _ ->
        let hashtbl = LangMap.find !deflang !langmsgs in
        Hashtbl.find hashtbl msgid
    in
    process str args
  with Not_found ->
    (*
    log#error "lang not found: [%s]\n" msgid;
     *)
    "[not found in lang pack: " ^ msgid ^ "]"
                
      
let update lang =
  try
    let htbl = Marshal.from_channel 
                 (open_in_bin (Filename.concat !langdir (lang ^ ext))) in
    langmsgs := LangMap.add lang htbl !langmsgs;
    "Updated"
  with exn ->
    Printexc.to_string exn
      
let expand_time ~lang cause seconds =
  let year, month, day, hour, min, sec = Strftime.seconds_to_string seconds in
  let f =
    try
      (LangTime.find lang !langtime).expand_time      
    with Not_found ->
      (LangTime.find !deflang !langtime).expand_time
  in
    f cause year month day hour min sec
      
let float_seconds lang cause seconds =
  let f =
    try
      (LangTime.find lang !langtime).float_seconds
    with Not_found ->
      (LangTime.find !deflang !langtime).float_seconds
  in
    f cause seconds
      
let update_msgid (lang:string) (msgid:string) (str:string option) =
  let htbl = LangMap.find lang !langmsgs in
    (match str with
       | None -> Hashtbl.remove htbl msgid
       | Some data ->
           if Hashtbl.mem htbl msgid then
             Hashtbl.replace htbl msgid data
           else
             Hashtbl.add htbl msgid data;
    );
    let mout = open_out_bin (Filename.concat !langdir (lang ^ ext)) in
      Marshal.to_channel mout htbl []
       
