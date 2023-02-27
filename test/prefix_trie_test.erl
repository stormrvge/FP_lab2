-module(prefix_trie_test).

-import(prefix_trie, [new/0, add/2, remove/2, add_word/3, get/2, map/2, filter/2, foldr/3, foldl/3, empty/0, is_monoid/1]).

-include_lib("eunit/include/eunit.hrl").

prefix_trie_test() ->
  % Test empty trie
  ?assertEqual(false, prefix_trie:contains([], empty())),

  % Test single value
  T1 = prefix_trie:add("hello", empty()),
  ?assertEqual(true, prefix_trie:contains("hello", T1)),
  ?assertEqual(false, prefix_trie:contains("world", T1)),

  % Test multiple values
  T2 = prefix_trie:add_word("world", 100, T1),
  T3 = prefix_trie:add_word("foo", 200, T2),
  T4 = prefix_trie:add_word("bar", 300, T3),
  T5 = prefix_trie:add_word("foobar", 400, T4),
  T6 = prefix_trie:add_word("foofoo", 500, T5),

  ?assertEqual(true, prefix_trie:contains("world", T6)),
  ?assertEqual(true, prefix_trie:contains("foo", T6)),
  ?assertEqual(true, prefix_trie:contains("bar", T6)),
  ?assertEqual(true, prefix_trie:contains("foobar", T6)),
  ?assertEqual(true, prefix_trie:contains("foofoo", T6)),
  ?assertEqual(false, prefix_trie:contains("fo", T6)),
  ?assertEqual(false, prefix_trie:contains("foob", T6)),

  ?assertEqual(100, prefix_trie:get("world", T6)),
  ?assertEqual(200, prefix_trie:get("foo", T6)),
  ?assertEqual(300, prefix_trie:get("bar", T6)),
  ?assertEqual(400, prefix_trie:get("foobar", T6)),
  ?assertEqual(500, prefix_trie:get("foofoo", T6)),

  % Test remove
  T7 = prefix_trie:remove("foofoo", T6),
  ?assertEqual(false, prefix_trie:contains("foofoo", T7)),

  T8 = prefix_trie:remove("world", T7),
  ?assertEqual(false, prefix_trie:contains("world", T8)),

  T9 = prefix_trie:remove("hello", T8),
  ?assertEqual(false, prefix_trie:contains("hello", T9)),

  % Test filter
  Filter = fun(S) -> length(S) > 3 end,
  T10 = prefix_trie:filter(Filter, T6),
  ?assertEqual(true, prefix_trie:contains("world", T10)),
  ?assertEqual(true, prefix_trie:contains("foobar", T10)),
  ?assertEqual(true, prefix_trie:contains("foofoo", T10)),
  ?assertEqual(false, prefix_trie:contains("foo", T10)),
  ?assertEqual(false, prefix_trie:contains("bar", T10)).
%%
%%  % Test map
%%  MapFn = fun(S) -> string:to_upper(S) end,
%%  T11 = prefix_trie:map(MapFn, T6),
%%  ?assertEqual(true, prefix_trie:lookup("WORLD", T11)),
%%  ?assertEqual(true, prefix_trie:lookup("FOOBAR", T11)),
%%  ?assertEqual(true, prefix_trie:lookup("FOOFOO", T11)),
%%  ?assertEqual(true, prefix_trie:lookup("FOO", T11)),
%%  ?assertEqual(true, prefix_trie:lookup("BAR", T11)).
%%
%%% Test foldl
%%test_foldl() ->
%%  {ok, Trie} = prefix_trie:new(),
%%  Trie2 = prefix_trie:add("abc", "value1", Trie),
%%  Trie3 = prefix_trie:add("abcd", "value2", Trie2),
%%  Trie4 = prefix_trie:add("ab", "value3", Trie3),
%%  Prefixes = [],
%%  Fun = fun(Key, Val, Acc) ->
%%    [Key | Acc]
%%        end,
%%  Res = prefix_trie:foldl(Fun, Prefixes, Trie4),
%%  ?assertEqual(["ab", "abc", "abcd"], Res).
%%
%%% Test is_monoid
%%test_is_monoid() ->
%%  {ok, Trie} = prefix_trie:new(),
%%  Trie2 = prefix_trie:add("abc", "value1", Trie),
%%  Trie3 = prefix_trie:add("abcd", "value2", Trie2),
%%  Trie4 = prefix_trie:add("ab", "value3", Trie3),
%%  Trie5 = prefix_trie:add("ab", "value4", Trie4),
%%  Trie6 = prefix_trie:remove("ab", Trie5),
%%  Zero = prefix_trie:empty(),
%%  ?assertEqual(true, prefix_trie:is_monoid(Trie)),
%%  ?assertEqual(true, prefix_trie:is_monoid(Trie4)),
%%  ?assertEqual(true, prefix_trie:is_monoid(Trie6)),
%%  ?assertEqual(true, prefix_trie:is_monoid(Zero)).
