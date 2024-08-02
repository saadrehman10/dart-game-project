import 'dart:math';

class Room {
  String description;
  Map<String, Gate> gates;

  Room(this.description) {
    gates = {};
  }

  void describe() {
    print(description);
    gates.forEach((direction, gate) {
      if (gate.isOpen) {
        print("There is an open gate to the $direction.");
      } else if (gate.needsPuzzle) {
        print("There is a puzzle-locked gate to the $direction.");
      } else {
        print("There is a locked gate to the $direction.");
      }
    });
  }

  void connect(String direction, Room room, {bool locked = false, bool puzzleLocked = false}) {
    gates[direction] = Gate(room, isOpen: !locked, needsPuzzle: puzzleLocked);
  }
}

class Gate {
  Room leadsTo;
  bool isOpen;
  bool needsPuzzle;

  Gate(this.leadsTo, {this.isOpen = true, this.needsPuzzle = false});
}

class Object {
  String name;
  String description;
  bool usable;

  Object(this.name, this.description, {this.usable = false});

  void use() {
    if (usable) {
      print("You use the $name.");
    } else {
      print("You can't use the $name.");
    }
  }
}

class Player {
  Room currentRoom;
  List<Object> inventory;

  Player(this.currentRoom) {
    inventory = [];
  }

  void move(String direction) {
    if (currentRoom.gates.containsKey(direction)) {
      var gate = currentRoom.gates[direction]!;
      if (gate.isOpen) {
        currentRoom = gate.leadsTo;
        currentRoom.describe();
      } else if (gate.needsPuzzle) {
        print("You need to solve a puzzle to open this gate.");
        // Implement puzzle logic here
      } else {
        print("The gate is locked.");
      }
    } else {
      print("You can't go that way.");
    }
  }

  void pickUp(Object object) {
    inventory.add(object);
    currentRoom.gates.remove(object);
    print("You picked up the ${object.name}.");
  }

  void useObject(String objectName) {
    for (var obj in inventory) {
      if (obj.name == objectName) {
        obj.use();
        return;
      }
    }
    print("You don't have a $objectName.");
  }
}

void createGrid(List<List<Room>> grid, int size) {
  var directions = ['north', 'south', 'east', 'west'];
  var rng = Random();

  for (var i = 0; i < size; i++) {
    for (var j = 0; j < size; j++) {
      var room = Room("Room [$i, $j]");
      grid[i][j] = room;
    }
  }

  for (var i = 0; i < size; i++) {
    for (var j = 0; j < size; j++) {
      if (i > 0) grid[i][j].connect('north', grid[i - 1][j], locked: rng.nextBool(), puzzleLocked: rng.nextBool());
      if (i < size - 1) grid[i][j].connect('south', grid[i + 1][j], locked: rng.nextBool(), puzzleLocked: rng.nextBool());
      if (j > 0) grid[i][j].connect('west', grid[i][j - 1], locked: rng.nextBool(), puzzleLocked: rng.nextBool());
      if (j < size - 1) grid[i][j].connect('east', grid[i][j + 1], locked: rng.nextBool(), puzzleLocked: rng.nextBool());
    }
  }
}

void displayMap(List<List<Room>> grid, Player player) {
  for (var i = 0; i < grid.length; i++) {
    for (var j = 0; j < grid[i].length; j++) {
      if (player.currentRoom == grid[i][j]) {
        print("[P]");
      } else {
        print("[ ]");
      }
    }
    print(""); // New line for each row
  }
}

void main() {
  const size = 3; // Change to 5 for hard mode
  var grid = List.generate(size, (_) => List<Room>.filled(size, Room(""), growable: false), growable: false);
  createGrid(grid, size);

  var rng = Random();
  var startRoom = grid[rng.nextInt(size)][rng.nextInt(size)];
  var goalRoom = grid[rng.nextInt(size)][rng.nextInt(size)];

  var player = Player(startRoom);

  // Start game
  print("Your goal is to reach the room at [${goalRoom.description}].");
  player.currentRoom.describe();
  
  // Display initial map
  displayMap(grid, player);

  // Example of interaction
  // Implement main game loop here for taking player commands
}
