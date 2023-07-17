
// Observables have a few different implementations
// and some other behaviour based on their pipeline.

// DEVELOPERS NOTE: dont use auto formatting for this file, it makes it way worse,
// having these repeating long signatures on line line each allows comparison from one to the next as we add new args

// These types track what kind the observable is operating with.

// Types for describing the "class" of an observable
type foreign // custom or otherwise
type subject
type behaviorsubject

// Subject based observables can be emitted to will have use source<int> etc as their source type
// Custom observables and observables derived from multiple sources will have void source type
type source<'a>
type void

// Observable
// class is a 'phantom type' to flag the implementation. see Class types above
// a is the source type for a subject, behaviorsubject
// Custom / Hot observables should be 'void'
// b is the output type.
type t<'class, 'a, 'b>

type err
type subscription
type scheduler

let void: t<'class, 'source, 'b> => unit = _ => ()

module Observer = {
  type t<'a> = t<foreign, source<'a>, void>
  @deriving(abstract)
  type make<'a> = {
    @optional next: 'a => unit,
    @optional error: err => unit,
    @optional complete: unit => unit,
  }

  external toT: make<'a> => t<'a> = "%identity"

  let make = (~next=?, ~error=?, ~complete=?, ()) => 
    make(~next?, ~error?, ~complete?, ())->toT
}

module Subscriber = {
  type t<'a>
  @send external next: (t<'a>, 'a) => unit = "next"
  @send external complete: t<'a> => unit = "complete"
  @send external error: (t<'a>, 'err) => unit = "complete"
}

@module("rxjs")
external asyncScheduler: scheduler = "asyncScheduler"

@module("rxjs")
external asapScheduler: scheduler = "asapScheduler"

module Observable = {
  @module("rxjs") @new external make: (Subscriber.t<'a> => option<() => unit>) => t<'c, 's, 'a> = "Observable"
}

module Subject = {
  type t<'a> = t<subject, source<'a>, 'a>
  @module("rxjs") @new external make: 'a => t<'a> = "Subject"
  @module("rxjs") @new external makeEmpty: unit => t<'a> = "Subject"
}

@send external next: (t<'class, source<'a>, 'b>, 'a) => unit = "next"

@send external pipe: (t<'class, 'source, 'a>, (. t<'class, 'source, 'a>) => t<'class, 'source, 'b>) => t<'class, 'source, 'b> = "pipe"
@send external pipe2: (t<'class, 'source, 'a>, ((. t<'class, 'source, 'a>) => t<'class, 'source, 'b>), ((. t<'class, 'source, 'b>) => t<'class, 'source, 'c>)) => t<'class, 'source, 'c> = "pipe"
@send external pipe3: (t<'class, 'source, 'a>, ((. t<'class, 'source, 'a>) => t<'class, 'source, 'b>), ((. t<'class, 'source, 'b>) => t<'class, 'source, 'c>), ((. t<'class, 'source, 'c>) => t<'class, 'source, 'd>)) => t<'class, 'source, 'd> = "pipe"
@send external pipe4: (t<'class, 'source, 'a>, ((. t<'class, 'source, 'a>) => t<'class, 'source, 'b>), ((. t<'class, 'source, 'b>) => t<'class, 'source, 'c>), ((. t<'class, 'source, 'c>) => t<'class, 'source, 'd>), ((. t<'class, 'source, 'd>) => t<'class, 'source, 'e>)) => t<'class, 'source, 'e> = "pipe"
@send external pipe5: (t<'class, 'source, 'a>, ((. t<'class, 'source, 'a>) => t<'class, 'source, 'b>), ((. t<'class, 'source, 'b>) => t<'class, 'source, 'c>), ((. t<'class, 'source, 'c>) => t<'class, 'source, 'd>), ((. t<'class, 'source, 'd>) => t<'class, 'source, 'e>), ((. t<'class, 'source, 'e>) => t<'class, 'source, 'f>)) => t<'class, 'source, 'f> = "pipe"
@send external pipe6: (t<'class, 'source, 'a>, ((. t<'class, 'source, 'a>) => t<'class, 'source, 'b>), ((. t<'class, 'source, 'b>) => t<'class, 'source, 'c>), ((. t<'class, 'source, 'c>) => t<'class, 'source, 'd>), ((. t<'class, 'source, 'd>) => t<'class, 'source, 'e>), ((. t<'class, 'source, 'e>) => t<'class, 'source, 'f>), ((. t<'class, 'source, 'f>) => t<'class, 'source, 'g>)) => t<'class, 'source, 'g> = "pipe"
@send external pipe7: (t<'class, 'source, 'a>, ((. t<'class, 'source, 'a>) => t<'class, 'source, 'b>), ((. t<'class, 'source, 'b>) => t<'class, 'source, 'c>), ((. t<'class, 'source, 'c>) => t<'class, 'source, 'd>), ((. t<'class, 'source, 'd>) => t<'class, 'source, 'e>), ((. t<'class, 'source, 'e>) => t<'class, 'source, 'f>), ((. t<'class, 'source, 'f>) => t<'class, 'source, 'g>), ((. t<'class, 'source, 'g>) => t<'class, 'source, 'h>)) => t<'class, 'source, 'h> = "pipe"

@send external subscribe: (t<'class, 'source, 'a>, t<'co, source<'a>, 'out>) => subscription = "subscribe"
@send external subscribe_: (t<'class, 'source, 'a>, t<'co, source<'a>, 'out>) => unit = "subscribe"
@send external unsubscribe: subscription => unit = "unsubscribe"

module BehaviorSubject = {
  type t<'a> = t<behaviorsubject, source<'a>, 'a>
  @module("rxjs") @new external make: 'a => t<'a> = "BehaviorSubject"
}

external toObservable: t<'c, 's, 'a> => t<foreign, void, 'a> = "%identity"

@module("rxjs") external buffer: (t<'ca, 'sa, 'a>, . t<'cb, 'sb, 'b>) => t<'cb, 'sb, array<'b>> = "buffer"
@module("rxjs") external catchError: (err => t<'class, 'source, 'a>, . t<'class, 'source, 'a>) => t<'class, 'source, 'a> = "catchError"

@module("rxjs") external combineLatest2: (t<'ca, 'sa, 'a>, t<'cb, 'sb, 'b>) => t<foreign, void, ('a, 'b)> = "combineLatest"
@module("rxjs") external combineLatest3: (t<'ca, 'sa, 'a>, t<'cb, 'sb, 'b>, t<'cc, 'sc, 'c>) => t<foreign, void, ('a, 'b, 'c)> = "combineLatest"
@module("rxjs") external combineLatest4: (t<'ca, 'sa, 'a>, t<'cb, 'sb, 'b>, t<'cc, 'sc, 'c>, t<'cd, 'sd, 'd>) => t<foreign, void, ('a, 'b, 'c, 'd)> = "combineLatest"
@module("rxjs") external combineLatest5: (t<'ca, 'sa, 'a>, t<'cb, 'sb, 'b>, t<'cc, 'sc, 'c>, t<'cd, 'sd, 'd>, t<'ce, 'se, 'e>) => t<foreign, void, ('a, 'b, 'c, 'd, 'e)> = "combineLatest"
@module("rxjs") external combineLatest6: (t<'ca, 'sa, 'a>, t<'cb, 'sb, 'b>, t<'cc, 'sc, 'c>, t<'cd, 'sd, 'd>, t<'ce, 'se, 'e>, t<'cf, 'sf, 'f>) => t<foreign, void, ('a, 'b, 'c, 'd, 'e, 'f)> = "combineLatest"
@module("rxjs") external combineLatest7: (t<'ca, 'sa, 'a>, t<'cb, 'sb, 'b>, t<'cc, 'sc, 'c>, t<'cd, 'sd, 'd>, t<'ce, 'se, 'e>, t<'cf, 'sf, 'f>, t<'cg, 'sg, 'g>) => t<foreign, void, ('a, 'b, 'c, 'd, 'e, 'f, 'g)> = "combineLatest"
@module("rxjs") external combineLatestArray: array<t<foreign, void, 'a>> => t<foreign, void, array<'a>> = "combineLatest"

@module("rxjs") external concatAll: (unit, . t<'co, 'so, t<'c, 's, 'b>>) => t<'co, 'so, 'b> = "concatAll"
@module("rxjs") external concatMap: ('a => t<foreign, void, 'b>, . t<'c, 's, 'a>) => t<'c, 's, 'b> = "concatMap"
@module("rxjs") external debounce: (t<'ca, 'sa, 'a>, . t<'cb, 'sb, 'b>) => t<'cb, 'sb, 'b> = "debounce"
@module("rxjs") external defer: (unit => t<'c, 's, 'a>) => t<foreign, void, 'a> = "defer"
@module("rxjs") external deferPromise: (unit => Js.Promise.t<'a>) => t<foreign, void, 'a> = "defer"
@module("rxjs") external delayWhen: (unit => t<'c, 's, ()>, . t<'c, 's, 'a>) => t<'c, 's, 'a> = "delayWhen"
@module("rxjs") external distinct: (unit, . t<'co, 'so, 'a>) => t<'co, 'so, 'a> = "distinct"
@module("rxjs") external distinctUntilChanged: ((. 'a, 'a) => bool, . t<'co, 'so, 'a>) => t<'co, 'so, 'a> = "distinctUntilChanged"

@module("rxjs") external filter: ('a => bool, . t<'c, 's, 'a>) => t<'c, 's, 'a> = "filter"
@module("rxjs") external finalize: (() => (), . t<'c, 's, 'a>) => t<'c, 's, 'a> = "finalize"

// type filter<'a, 'c, 's>> = {
//   fn: ('a => bool, . t<'c, 's, 'a>) => t<'c, 's, 'a>
// }
// let filter = { fn: filter }

@module("rxjs") external fromArray: array<'a> => t<foreign, void, 'a> = "from"
@module("rxjs") external fromPromise: Js.Promise.t<'a> => t<foreign, void, 'a> = "from"
@module("rxjs") external fromPromiseSched: (Js.Promise.t<'a>, scheduler) => t<foreign, void, 'a> = "from"
@module("rxjs") external interval: int => t<foreign, void, int> = "interval"
@module("rxjs") external last: (unit, . t<'c, 's, 'a>) => t<'c, 's, 'a> = "last"
@module("rxjs") external lastValueFrom: t<'c, 's, 'a> => Js.Promise.t<'a> = "lastValueFrom"
@module("rxjs") external map: (. ('a, int) => 'b, . t<'c,'s,'a>) => t<'c, 's, 'b> = "map"
let const: ('b, . t<'c, 's, 'a>) => t<'c, 's, 'b> = (b) => map(. (_, _) => b)


@module("rxjs") external merge2: (t<'ca, 'sa, 'a>, t<'cb, 'sb, 'a>) => t<foreign, void, 'a> = "merge"
@module("rxjs") external merge3: (t<'ca, 'sa, 'a>, t<'cb, 'sb, 'a>, t<'cc, 'sc, 'a>) => t<foreign, void, 'a> = "merge"
@module("rxjs") external merge4: (t<'ca, 'sa, 'a>, t<'cb, 'sb, 'a>, t<'cc, 'sc, 'a>, t<'cd, 'sd, 'a>) => t<foreign, void, 'a> = "merge"
@module("rxjs") external merge5: (t<'ca, 'sa, 'a>, t<'cb, 'sb, 'a>, t<'cc, 'sc, 'a>, t<'cd, 'sd, 'a>, t<'ce, 'se, 'a>) => t<foreign, void, 'a> = "merge"
@module("rxjs") external merge6: (t<'ca, 'sa, 'a>, t<'cb, 'sb, 'a>, t<'cc, 'sc, 'a>, t<'cd, 'sd, 'a>, t<'ce, 'se, 'a>, t<'cf, 'sf, 'a>) => t<foreign, void, 'a> = "merge"
@module("rxjs") external merge7: (t<'ca, 'sa, 'a>, t<'cb, 'sb, 'a>, t<'cc, 'sc, 'a>, t<'cd, 'sd, 'a>, t<'ce, 'se, 'a>, t<'cf, 'sf, 'a>, t<'cg, 'sg, 'a>) => t<foreign, void, 'a> = "merge"
@module("rxjs") external mergeMap: ('a => t<'cb, 'sb, 'b>, . t<'ca, 'sa, 'a>) => t<'ca, 'sa, 'b> = "mergeMap"
@module("rxjs") external mergeAll: (unit, . t<'ca, 'sa, t<'c, 's, 'b>>) => t<'ca, 'sa, 'b> = "mergeAll"
@module("rxjs") external return: 'a => t<foreign, void, 'a> = "of" // of is keyword so rename
@module("rxjs") external scan: ( ('b, 'a, int) => 'b, 'b, . t<'ca, 'sa, 'a>) => t<'ca, 'sa, 'b> = "scan"
@module("rxjs") external share: (unit, . t<'ca, 'sa, 'a>) => t<'ca, 'sa, 'a> = "share"
@module("rxjs") external shareReplay: (int, . t<'ca, 'sa, 'a>) => t<'ca, 'sa, 'a> = "shareReplay"
@module("rxjs") external startWith: ('a, .t<'ca, 'sa, 'a>) => t<'ca, 'sa, 'a> = "startWith"
@module("rxjs") external switchMap: ('a => t<'cb, 'sb, 'b>, . t<'ca, 'sa, 'a>) => t<'ca, 'sa, 'b> = "switchMap"
@module("rxjs") external take: (int, . t<'ca, 'sa, 'a>) => t<'ca, 'sa, 'a> = "take"
@module("rxjs") external tap: ('a => unit, . t<'ca, 'sa, 'a>) => t<'ca, 'sa, 'a> = "tap"
@module("rxjs") external tapErrorComplete: ('a => unit, err => unit, unit => unit, . t<'ca, 'sa, 'a>) => t<'ca, 'sa, 'a> = "tap"
type timeinterval<'a> = { interval: int, value: 'a }
@module("rxjs") external timeInterval: (unit, . t<'ca, 'sa, 'a>) => t<'ca, 'sa, timeinterval<'a>> = "timeInterval"
@module("rxjs") external toArray: (unit, . t<'ca, 'sa, 'a>) => t<'ca, 'sa, array<'a>> = "toArray"
@module("rxjs") external withLatestFrom: (t<'ca, 'sa, 'a>, . t<'cz, 'sz, 'z>) => t<'cz, 'sz, ('z, 'a)> = "withLatestFrom"
@module("rxjs") external withLatestFrom2: (t<'ca, 'sa, 'a>, t<'cb, 'sb, 'b>, . t<'cz, 'sz, 'z>) => t<'cz, 'sz, ('z, 'a, 'b)> = "withLatestFrom"
@module("rxjs") external withLatestFrom3: (t<'ca, 'sa, 'a>, t<'cb, 'sb, 'b>, t<'cc, 'sc, 'c>, . t<'cz, 'sz, 'z>) => t<'cz, 'sz, ('z, 'a, 'b, 'c)> = "withLatestFrom"
@module("rxjs") external withLatestFrom4: (t<'ca, 'sa, 'a>, t<'cb, 'sb, 'b>, t<'cc, 'sc, 'c>, t<'cd, 'sd, 'd>, . t<'cz, 'sz, 'z>) => t<'cz, 'sz, ('z, 'a, 'b, 'c, 'd)> = "withLatestFrom"
@module("rxjs") external withLatestFrom5: (t<'ca, 'sa, 'a>, t<'cb, 'sb, 'b>, t<'cc, 'sc, 'c>, t<'cd, 'sd, 'd>, t<'ce, 'se, 'e>, . t<'cz, 'sz, 'z>) => t<'cz, 'sz, ('z, 'a, 'b, 'c, 'd, 'e)> = "withLatestFrom"
@module("rxjs") external withLatestFrom6: (t<'ca, 'sa, 'a>, t<'cb, 'sb, 'b>, t<'cc, 'sc, 'c>, t<'cd, 'sd, 'd>, t<'ce, 'se, 'e>, t<'cf, 'sf, 'f>, . t<'cz, 'sz, 'z>) => t<'cz, 'sz, ('z, 'a, 'b, 'c, 'd, 'e, 'f)> = "withLatestFrom"
@module("rxjs") external withLatestFrom7: (t<'ca, 'sa, 'a>, t<'cb, 'sb, 'b>, t<'cc, 'sc, 'c>, t<'cd, 'sd, 'd>, t<'ce, 'se, 'e>, t<'cf, 'sf, 'f>, t<'cg, 'sg, 'g>, . t<'cz, 'sz, 'z>) => t<'cz, 'sz, ('z, 'a, 'b, 'c, 'd, 'e, 'f, 'g)> = "withLatestFrom"

let keepMap: ('a => option<'b>, . t<'ca, 'sa, 'a>) => t<'ca, 'sa, 'b> = (f, . xs) => {
  xs->pipe3(
    map(.(a, _) => f(a)),
    filter(Js.Option.isSome),
    map(.(a, _) => Js.Option.getExn(a))
  )
}

let distinctBy = (fn: 'a => 'b) => {
  (. source: t<'class, 'source, 'a>): t<'class, 'source, 'a> => {
    Observable.make( (subscriber) => {
      let last = ref(None)
      let sub = source->subscribe(Observer.make(
        ~next=(x) => {
          let fnx = fn(x)
          if( Some(fnx) != last.contents) {
            last.contents = Some(fnx)
            subscriber->Subscriber.next(x)
          } else {
            ()
          }
        },
        ~error=Subscriber.error(subscriber),
        ~complete=() => Subscriber.complete(subscriber),
        ()))
      Some(() => unsubscribe(sub))
    })
}
}

