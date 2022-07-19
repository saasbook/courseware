// Run this file with node, i.e. node disc6.js

console.log("Question 2: WWJD");

console.log("Question 2.1: Boolean");
console.log((undefined==null), (NaN==NaN), (null==false), (0==false), (""==false));

console.log("\nQuestion 2.2: Arrays");
console.log([1, 2, 3] + [4, 5, 6]);
console.log(!![]);
console.log(([] == true));
console.log([10, 1, 3].sort());
console.log(([] == 0));

console.log("\nQuestion 3: Closures | Output: ");
function foo(x) {
  var baz = 3;
  return function (y) {
    console.log(x + y + (baz++));
  }
}
var bar = foo(5);
bar(11);

console.log("\nQuestion 6: Classes | Implementation in File");

class Pokemon {
  constructor(HP, attack, defense) {
    this.HP = HP;
    this.attack = this.attack;
    this.defense = this.defense;
    this.move = "";
    this.level = 1;
    this.type = ""
  }

  fight() {
    throw "No move specified";
  }

  canFly() {
    if (this.type) {
      if (this.type.includes("flying")) {
        return true;
      } else {
        return false;
      }
    } else {
      throw "No type specified";
    }
  }
}

class Charizard extends Pokemon {
  constructor(HP, attack, defense, move) {
    super(HP, attack, defense);
    this.move = move;
    this.type = "fire/flying";
  }

  fight() {
    if (move) {
      console.log("Charizard used the move " + this.move + "!");
      return this.attack;
    } else {
      super.fight();
    }
  }
}
