# SaraikiScript - A Saraiki Programming Language

## Overview
SaraikiScript is a Saraiki-inspired programming language created for the Compiler Construction course. It uses authentic Saraiki vocabulary to make programming accessible to Saraiki speakers from Southern Punjab, Pakistan.

## Language Philosophy
SaraikiScript represents the 20+ million Saraiki speakers of Southern Punjab (Multan, Bahawalpur, Dera Ghazi Khan regions), making programming accessible in their native language while preserving cultural identity in technology.

---

## Keywords (15 total)

| Keyword | Meaning | C++ Equivalent | Example Usage |
|---------|---------|----------------|---------------|
| je | if | if | `je (x > 0)` |
| bia | else | else | `bia { }` |
| jein_tak | while | while | `jein_tak (x < 10)` |
| wastey | for | for | `wastey (i=0; i<5; i++)` |
| kar | do/execute | - | `kar function()` |
| wapas | return | return | `wapas 0;` |
| te | and | && | `je (a te b)` |
| ya | or | \|\| | `je (a ya b)` |
| koh | not | ! | `je (koh flag)` |
| sach | true | true | `bool x = sach;` |
| Koor | false | false | `bool y = Koor;` |
| kaam | function | function | `kaam add() { }` |
| das | input | cin | `das >> x;` |
| vikha | output | cout | `vikha << "Hello";` |
| buniyad | main | main | `kaam buniyad() { }` |

---

## Sample Code

### Hello World
```saraikiscript
kaam buniyad() {
    vikha << "Hello World";
    wapas 0;
}
```

### Input/Output
```saraikiscript
kaam buniyad() {
    int x;
    vikha << "Enter a number: ";
    das >> x;
    vikha << "You entered: " << x;
    wapas 0;
}
```

### Conditional Statement
```saraikiscript
kaam buniyad() {
    int age = 20;
    
    je (age >= 18) {
        vikha << "Adult";
    }
    bia {
        vikha << "Minor";
    }
    
    wapas 0;
}
```

### Loops
```saraikiscript
kaam buniyad() {
    // While loop
    int i = 0;
    jein_tak (i < 5) {
        vikha << i;
        i++;
    }
    
    // For loop
    wastey (int j = 0; j < 3; j++) {
        vikha << j;
    }
    
    wapas 0;
}
```

### Functions
```saraikiscript
kaam add(int a, int b) {
    wapas a + b;
}

kaam buniyad() {
    int sum = kar add(5, 3);
    vikha << "Sum: " << sum;
    wapas 0;
}
```

---

## How to Compile and Run

### Prerequisites
```bash
sudo apt install flex gcc libfl-dev
```

### Step 1: Generate Lexical Analyzer
```bash
flex scanner.l
```

### Step 2: Compile
```bash
gcc lex.yy.c -o scanner -lfl
```

### Step 3: Run Scanner on Test Program
```bash
./scanner test_program.srk > tokens.txt 2> error.log
```

### Step 4: View Output
```bash
# View tokens
cat tokens.txt

# View errors (if any)
cat error.log
```

---

## Project Structure
```
SaraikiScript/
├── scanner.l                       # Lex specification file
├── test_program.srk                # Clean test program
├── test_errors.srk                 # Test program with errors
├── tokens.txt                      # Token output
├── error.log                       # Error output
├── SaraikiScript Video.mp4         # Error output
└── README.md                       # This file
```

---

## Token Format

Each token is printed in the format:
```
Line <n>: <Token Type> → <Lexeme>
```

**Example:**
```
Line 1: KEYWORD → kaam
Line 1: KEYWORD → buniyad
Line 2: DATA_TYPE → int
Line 2: IDENTIFIER → x
Line 2: ASSIGNMENT → =
Line 2: INTEGER → 10
```

**Error Format:**
```
Line 7: ERROR → @salary (invalid identifier)
Line 8: ERROR → # (unrecognized symbol)
```

---

## Author
**JAWAD AHMAD - L1F22BSCS0316**  

---

**SaraikiScript - Programming in Saraiki, by Saraiki speakers, for Saraiki speakers.** 🇵🇰
