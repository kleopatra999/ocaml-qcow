(*
 * Copyright (C) 2015 David Scott <dave.scott@unikernel.com>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)

type offset =
  | Bytes of int64            (** octets from beginning of file *)
  | PhysicalSectors of int64  (** physical sectors on the underlying disk *)
  | Clusters of int64         (** virtual clusters in the qcow image *)
with sexp

type t = {
	offset: offset;
	copied: bool; (* refcount = 1 implies no snapshots implies direct write ok *)
	compressed: bool;
}
with sexp

val shift: t -> int64 -> t
(** [shift t bytes] adds [bytes] to t, maintaining other properties *)

val make: int64 -> t
(** Create an offset at the given byte address *)

val to_sector: sector_size:int -> cluster_bits:int -> t -> int64 * int
val to_bytes: sector_size:int -> cluster_bits:int -> t -> int64
val to_cluster: sector_size:int -> cluster_bits:int -> t -> int64 * int

include S.PRINTABLE with type t := t
include S.SERIALISABLE with type t := t