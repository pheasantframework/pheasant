// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.


import 'dart:async' show Future, Stream, StreamController;
import 'dart:html' show Event, Element;

import 'package:pheasant_meta/pheasant_meta.dart'
    show From, PheasantUnimplementedError, PheasantError;

import '../base.dart';

/// Mixin for base definition of state control functions.
///
/// The functions defined in this mixin represent the base functions required to represent state management and state control.
/// These functions are used to show characteristics of state, such as pausing state via `freeze`, unpausing state via `unfreeze` and refreshing state via `reload`.
mixin StateControl {
  /// Function used to freeze state.
  ///
  /// When this function is called, the state of the desired object is paused, and so state changes are no longer implemented until state is unfrozen via the [unfreeze] function.
  void freeze();

  /// Function used to unfreeze state.
  ///
  /// When this function is called, the state of the desired object is unpaused, and so state changes can now be implemented.
  void unfreeze();

  /// Function used to refresh or reload state.
  ///
  /// When this function is called, the state of the desired object is refreshed back to its initial state, and so state changes are either cleared, or redirected back to initial state.
  void reload();
}

/// This is a mixin used to define base functions used in controlling state in a component.
///
/// In components, state is used and watched constantly, and so these are base function definitions of functions used in component states, alongside the [StateControl] mixin.
///
/// These functions are [applyState], which are used to copy and paste state from one phase or part of the component to another; and [dispose].
mixin ComponentStateControl {
  /// Function used in making a copy of the current state of an object to be implemented elsewhere in code.
  void applyState();

  /// Function used in disposing current component state, and disposing of any broadcast streams used in the process.
  void dispose();
}

/// The base class to represent State in an object.
///
/// This is the smallest representation of state in the Pheasant Framework. It is a generic class containing base functionality used to represent how state is controlled and managed in an application.
///
/// In this base class, we get to see a small representation of state management via the implementation of [initValue], [currentValue] and [previousValue], as well as the function [change].
///
/// This class is extended, implemented and used in other classes for state control, and is directly used by [StateObject], where most of the defined functions are implemented.
abstract class State<T> with StateControl {
  /// The initial value of the variable.
  final T initValue;

  late T _previousValue;
  // ignore: prefer_final_fields
  late T _currentValue;

  State({required this.initValue, T? newValue})
      : _currentValue = newValue ?? initValue,
        _previousValue = initValue;

  /// The current value of the variable
  T get currentValue => _currentValue;

  /// The previous value of the variable
  T get previousValue => _previousValue;

  /// Function used to change state.
  ///
  /// This function receives the new value of state and preforms changes to the [currentValue] and the [previousValue].
  void change(T newValue, {StateChange<T>? stateChange});
}

/// Class used to represent state changes in an application.
///
/// Whenever state changes, the changes that occur during the state transition are encapsulated in a [StateChange] class.
/// This class encapsulates data such as the [Event] that caused this change, the [StateTarget], and the [newValue] created from this state change.
///
/// This class is not used directly in the application, but used as a means of state change transmission in a component state object like [AppState].
class StateChange<T> {
  /// The event that triggered the state change
  Event? triggerEvent;

  /// The new value of the variable changed during the state change
  T? newValue;
  dynamic Function(dynamic)? stateChanger;

  StateTarget? _target;

  /// The target of the state change.
  StateTarget? get target => _target;

  /// Whether the state change has a target or not
  bool get targetless => _target == null;

  StateChange({
    required this.triggerEvent,
    required this.newValue,
    this.stateChanger,
    StateTarget? target,
  }) : _target = target;

  /// Constructor to initalise "no change" or an empty state change.
  StateChange.empty()
      : triggerEvent = null,
        newValue = null;
}

// TODO: Implement this class
class StateTarget {}

/// This is the class that makes use of the [State] class, with proper definitions of overriden functions from [State].
///
/// This class is used directly in other component state classes in instantiating state on a value, or variable defined with type [T].
/// The state of such variable is recorded by instantiating its [initValue], and then updating the [currentValue] via changes recorded by [change].
///
/// Concrete implementations of [freeze], [unfreeze] and [reload] are given here.
class StateObject<T> extends State<T> {
  bool _changeable = true;

  @override
  // ignore: overridden_fields
  late T _currentValue;

  StateObject({required super.initValue, T? newValue})
      : _currentValue = newValue ?? initValue;

  @override
  void change(T newValue, {StateChange<T>? stateChange}) {
    if (_changeable) {
      _previousValue = _currentValue;
      _currentValue = newValue;
    }
  }

  @override
  void freeze() => _changeable = false;

  @override
  void unfreeze() => _changeable = true;

  @override
  void reload() {
    change(initValue);
  }
}

/// The base component state class used in controlling state in a component or object.
///
/// This class contains much more concrete ways of controlling, handling and watching state in a component through the use of streams.
/// These streams watch for state changes and then are updated whenever a state change is received.
///
/// This object also encapsulates the state of the component via the [State] object.
///
/// This object makes use of the [ComponentStateControl] mixin as well as the [StateControl] mixin to create implementations of functions required for state changes.
class ElementState<T> extends State<T>
    with StateControl, ComponentStateControl {
  final StreamController<StateChange<T>> _stateController =
      StreamController<StateChange<T>>.broadcast();

  /// A [Stream] of state changes used and updated for watching over changes in state of the element or component.
  Stream<StateChange<T>> get stateStream => _stateController.stream;

  /// The current state of the component as a [State] object.
  State<T> componentState;

  /// The component
  T component;

  ElementState({required this.component, State<T>? state})
      : componentState = state ?? StateObject<T>(initValue: component),
        super(initValue: component);

  @override
  void freeze() {
    componentState.freeze();
  }

  @override
  void reload() {
    componentState.reload();
  }

  @From('0.1.3')
  @override
  void applyState() {
    throw PheasantUnimplementedError('Not yet implemented yet');
  }

  @override
  void unfreeze() {
    componentState.unfreeze();
  }

  @override
  void dispose() {
    _stateController.close();
  }

  @override
  void change(T newValue, {StateChange<T>? stateChange}) {
    componentState.change(newValue, stateChange: stateChange);
    _stateController.add(
        stateChange ?? StateChange(triggerEvent: null, newValue: newValue));
  }
}

/// Class used in encapsulating the emission of state changes.
///
/// This class is used in controlling the emission of changes in state to a variable, with functions like [emit] and [emitStream].
class ChangeEmitter<T> {
  final _valueController = StreamController<T>.broadcast();

  /// Stream for listening to variable value changes
  late Stream<T> emittedStream = _valueController.stream;

  /// Function used in emitting state changes
  void emit() {}

  /// Function used in emitting a stream of state changes
  void emitStream(
    Stream<T> stream,
    /*ChangeReceiver<T> receiver*/
  ) {
    emittedStream = stream;
  }

  void dispose() {
    _valueController.close();
  }
}

/// Class used in encapsulating the emission of state changes.
///
/// This class is used in controlling the emission of changes in state to a variable, with functions like [emit] and [emitStream].
class ChangeReceiver<T> {
  final _valueController = StreamController<T>.broadcast();

  // Stream for listening to variable value changes
  Stream<T> get receivedStream => _valueController.stream;

  /// Function used in receiving state changes
  void receive() {}

  /// Function used in emitting a stream of state changes
  void receiveStream(
    Stream<T> stream,
    /*ChangeReceiver<T> receiver*/
  ) {}

  void dispose() {
    _valueController.close();
  }
}

/// A state watcher class
///
/// This class is used in watching variables for state changes, and is able to recieve and emit state changes.
///
/// This is used in watching specific variables that can be referenced by their type [T] and their initial value [initValue]
class ChangeWatcher<T>
    with StateControl, ComponentStateControl
    implements ChangeEmitter<T>, ChangeReceiver<T> {
  /// The initial value of the watched variable.
  T initValue;

  /// The state of the watched variable
  State<T> initialState;

  /// The current state change that has occured on the watched variable and [initialState], or `null` if there have been no recent changes.
  StateChange<T>? currentStateChange;

  /// The current value of the watched variable
  T get currentValue => initialState.currentValue;

  bool _freeze = false;

  ChangeWatcher({required this.initValue, State<T>? state})
      : initialState = StateObject(initValue: initValue);

  @override
  void emit() {}

  @override
  void receive() {}

  Future<State<T>> get currentState async => StateObject(initValue: initValue)
    ..change(await _valueController.stream.last);

  /// [StreamController] to handle variable value changes
  @override
  final _valueController = StreamController<T>.broadcast();

  /// Stream for listening to variable value changes
  Stream<T> get valueStream => _valueController.stream;

  /// Function used to watch the variable for changes.
  ///
  /// This function checks for changes in the variable and streams state changes whenver a change is denoted.
  void watchVariable(T variable) {
    if (!_freeze) {
      // Notify listeners whenever the variable changes
      _valueController.add(variable);
    }
  }

  void ping() {}

  @override
  void freeze() {
    _valueController.stream.listen((event) {}).pause();
    _freeze = true;
  }

  @override
  void reload() {
    initialState.change(initValue);
    _valueController.add(initValue);
  }

  /// Dispose method to close the stream when no longer needed
  @override
  void dispose() {
    _freeze = false;
    _valueController.close();
  }

  @override
  void unfreeze() {
    _valueController.stream.listen((event) {}).resume();
    _freeze = false;
  }

  @override
  void applyState() => throw PheasantUnimplementedError();

  @override
  void emitStream(Stream<T> stream) => throw PheasantUnimplementedError();

  @override
  Stream<T> get emittedStream =>
      throw PheasantError(what: "Watcher can only have one stream");

  @override
  void receiveStream(
    Stream<T> stream,
    /*ChangeReceiver<T> receiver*/
  ) =>
      throw PheasantUnimplementedError();

  @override
  Stream<T> get receivedStream =>
      throw PheasantError(what: "Watcher can only have one stream");

  @override
  set emittedStream(Stream<T> emittedStream) {
    throw PheasantError(what: "Watcher can only have one stream");
  }
}

/// Mixin for the new [ElementChangeWatcher] object, an object specifically used for changes between parent and children in [PheasantTemplate] objects.
///
/// This mixin holds the functionality of storing and releasing the state of the object through the [Element.replaceWith] function.
mixin HtmlElementStateControl {
  /// The current reference to the element rendered by the component being watched by the [ChangeWatcher].
  Element? _reference;

  /// The initial reference to the element rendered by the component being watched by the [ChangeWatcher].
  Element? _initialRef;

  /// Function used to initialise the element reference.
  void initialiseReference(Element element) {
    _initialRef = element;
  }

  /// Function used to set the current element reference, used to measure state.
  void setReference(Element element) {
    _reference = element;
  }

  /// Function called after a state change made by the parent to reproduce the current state of the element.
  ///
  /// In future versions, the functionality here may be replaced by a [State] object on [Element].
  void reflectChanges() {
    if (_reference != null) _initialRef?.replaceWith(_reference!);
  }
}

/// A special extended class of [ChangeWatcher] used to control the state of not only the [PheasantTemplate] object, but the [Element] rendered by the file.
///
/// When a state change is caused by the parent, it could refresh the changes on the [PheasantTemplate] file, including the changes made on the [Element] and its children elements rendered by the object.
///
/// In order to store and reproduce these changes, the [ElementChangeWatcher] object has added functionality by the [HtmlElementStateControl] mixin to be able to control the state of children elements that will undergo these state changes.
class ElementChangeWatcher<U extends PheasantTemplate> extends ChangeWatcher<U>
    with HtmlElementStateControl {
  ElementChangeWatcher({required U initValue, State<U>? state})
      : super(initValue: initValue, state: state);
}

/// The class used in Pheasant Template Components. This class extends the base class [ElementState] with functionality used directly in controlling state in an application.
///
/// In every pheasant state object, there is an emitter - [ChangeEmitter] - and a receiver [ChangeReceiver] - used in receiving and emitting changes.
///
/// This object has the ability to do most of the state functionality that can be done in an [ElementState] or [StateObject] object, but has a few additional functions like [emit] and [receive].
class TemplateState extends ElementState<PheasantTemplate> {
  /// The watchers used to watch changes in an application.
  List<ChangeWatcher> watchers = [];

  /// Constructor to create a [TemplateState] object.
  ///
  /// Ensure to pass [watchers] as a growable list - [List.empty] for instance - else watchers would not be able to be registered.
  TemplateState(
      {required super.component,
      PheasantTemplate? initState,
      this.watchers = const <ChangeWatcher>[],
      this.disposeState})
      : initState = initState ?? component,
        emitter = ChangeEmitter(),
        receiver = ChangeReceiver();

  bool _frozen = false;

  /// Whether the state has been paused or not
  bool get onPause => _frozen;

  /// The initial state of the component - used to initialise state in a pheasant component
  PheasantTemplate initState;

  /// The disposing state
  PheasantTemplate? disposeState;

  ChangeEmitter emitter;
  ChangeReceiver receiver;

  void _streamChange(PheasantTemplate? templateChange,
      StateChange<PheasantTemplate> newChange) {
    if (!_frozen) {
      if (templateChange != null) componentState.change(templateChange);
      _stateController.add(newChange);
    }
  }

  /// Function used to emit state changes in a [PheasantTemplate] object.
  ///
  /// This function creates, emits and registers a [StateChange] by making use of [event] and [templateState].
  ///
  /// The function then registers the change and adds it to the [Stream].
  void emit(Event event, {PheasantTemplate? templateState}) {
    if (!_frozen) {
      StateChange<PheasantTemplate> change = StateChange(
          triggerEvent: event, newValue: templateState); // Set state change
      emitter.emit(); // Unimplemented yet
      _streamChange(templateState, change);
      receiver.receive(); // Unimplemented yet
    }
  }

  /// Function used to receive state changes in a [PheasantTemplate] object.
  void receive<T>(StateChange stateChange, T refVariable) {}

  @override
  void dispose() {
    if (disposeState != null) component = disposeState!;
    super.dispose();
  }

  /// Function used to register and add a [ChangeWatcher] for the application
  void registerWatcher<T>(State<T> variableState, T variable,
      {ChangeWatcher<T>? watcher}) {
    watchers.add(
        watcher ?? ChangeWatcher<T>(initValue: variable, state: variableState));
  }

  /// Function used to remove a [ChangeWatcher]
  void removeWatcher<T>(ChangeWatcher watcher, {T? reference}) {
    watchers.removeWhere((element) => element == watcher);
  }
}

/// Object to represent the application's state
///
/// This object represents the whole Pheasant Application State, and contains all functionality needed for controlling state in a pheasant application.
///
/// This object contains functionality to control state throughout an application, and also contains a list of [ChangeWatcher]s to watch for changes throughout the cycle of an application.
///
/// The object can emit, receive, register changes and more for the application.
class AppState extends TemplateState {
  /// The initial state of the application
  @override
  // ignore: overridden_fields
  State<PheasantTemplate> componentState;

  StateChange<PheasantTemplate> _stateChange;

  State<PheasantTemplate> get currentState => componentState;

  /// The watchers used to watch changes in an application.
  @override
  List<ChangeWatcher> get watchers;

  AppState(
      {required PheasantTemplate component,
      List<ChangeWatcher> watchers = const [],
      PheasantTemplate? initState,
      PheasantTemplate? disposeState})
      : componentState = StateObject(initValue: component),
        _stateChange = StateChange.empty(),
        super(
            initState: initState,
            component: component,
            watchers: watchers,
            disposeState: disposeState);

  /// The current state change in an application
  StateChange<PheasantTemplate> get stateChange => _stateChange;

  /// Stream for listening to state changes
  @override
  Stream<StateChange<PheasantTemplate>> get stateStream =>
      _stateController.stream;

  @override
  void _streamChange(PheasantTemplate? templateChange,
      StateChange<PheasantTemplate> newChange) {
    if (!_frozen) {
      if (templateChange != null) componentState.change(templateChange);
      _stateController.add(newChange);
      _stateChange = newChange;
    }
  }

  @override
  void emit(Event event, {PheasantTemplate? templateState}) {
    if (!_frozen) {
      StateChange<PheasantTemplate> change = StateChange(
          triggerEvent: event, newValue: templateState); // Set state change
      emitter.emit(); // Unimplemented yet
      // super.emit(event, templateState: templateState);
      _streamChange(templateState, change);
    }
  }

  @override
  void receive<T>(StateChange stateChange, T refVariable) =>
      throw PheasantUnimplementedError("Not yet implemented yet");

  @override
  void freeze() {
    componentState.freeze();
    for (var element in watchers) {
      element.freeze();
    }
    _frozen = true;
  }

  @override
  void unfreeze() {
    componentState.unfreeze();
    for (var element in watchers) {
      element.unfreeze();
    }
    _frozen = false;
  }

  @override
  void reload() {
    for (var element in watchers) {
      element.reload();
    }
    _stateChange = StateChange.empty();
    componentState.reload();
  }
}

@From('0.1.3')
extension ExtraFunctionality on TemplateState {
  void watch() {}

  void applyState() {}
}

@From('0.2.0')
extension TimedState on ComponentStateControl {
  /// Will treat this later on
  void hold(Duration timeDuration) {}

  void temporaryState() {}
}

/// other annotations: `@binding`, `@observe`,
// @state
// var num = 9;

// TODO: Add segmented state and state for certain components only
