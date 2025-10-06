+++
date = '2025-10-01T09:07:45-05:00'
title = 'Python For DevOps'
+++

## INTRODUCTION
### Why Python?
- Readability and maintainability
- Cross-Platform
- Versatility
- Libraries and modules
- Error handling
- Object-Oriented

### Shell Scripting
- System automation
- Direct interaction with the OS
- Simplicity for small tasks
- Speed for small operations

### Python Vs Shell Scripting

| Feature     | Python                                                             | Shell Scripting                                             |
| ----------- | ------------------------------------------------------------------ | ----------------------------------------------------------- |
| Syntax      | Clean                                                              | Compact but can be cryptic for complex logic                |
| Plaftorm    | Cross-platform                                                     | Unix/Linux                                                  |
| Libraries   | Extensive                                                          | Limited                                                     |
| Easy        | Excellent for complex tasks                                        | Can be complicated with conditionals                        |
| Best for    | General purpose scripting<br>data processing<br>complex automation | System administration                                       |
| When to use | Error handling<br>work with API                                    | Simple tasks on Unix/Linux<br>Directly interact with system |

## HOW TO BEGIN PYTHON CODING
**Text Editors:**
- VS Code
- Sublime Text
**IDEs:**
- PyCharm
- Thonny
**Online:**
- Codespaces (GitHub)
- Google Colab

## PYTHON DATA TYPES
**Numeric Types:**
- Integer `int` - `x = 10`
- Float `float` - `y = 10.5`
- Complex `complex` - `z = 3 + 5j`

**Sequence Types:**
- String `str` - `s = "Hello"`
- List `list` - Mutable - `l = [1,2.5,"apple"]`
```python
serversIP = ["192.168.1.1", "192.168.1.2", "192.168.1.3"]
serversIP.append("192.168.1.4")
print("List of Servers IP after append: ", serversIP)
```

- Tuple `tuple` - Ordered Inmutable - `t = (1,2,3)`

**Mapping Type:**
- Dictionary `dict` - Mutable key-value pairs, Keys must be unique and inmutable - `d = {"name": "John", "age": 25}`
```python
employee = {
    "name": "John Doe",
    "age": 30,
    "position": "Software Engineer",
    "salary": 9000
}
employee["department"] = "IT"
employee["salary"] = 9500
print("Employee after adding department: ", employee)
print("Employee salary after updating salary: ", employee["salary"])
```

**Set Type:**
- Set `set` - Unordered, mutable and unique (add or remove but can't change) - `s = {1,2,3}`
```python
my_sets = {1,2,3,4,5,6,7}
my_sets.add(8)
print("My Set after add: ", my_sets)
```
- Frozen Set `frozenset` - Like set but inmutable - `fr = frozenset([1,2,3])`

**Boolean Type:**
- Boolean `bool` - True or false (result of comparison operators) - `b = True`
```python
is_server_up = True
if is_server_up:
  print("The server is running!")
else:
  print("The server is Down!")
  
a = 10
b = 20
is_equal = a == b # Comparison for equality
is_greater = a > b # Comparison for greater than
print(is_equal) # Output: False
print(is_greater) # Output: False
```

**Binary Type:**
- Bytes `bytes` - Inmutable sequences of bytes - `b = b'Hello`
- Bytearray `bytearray` - Mutable sequences - `ba = bytearray(5)`
- Memory View `memoryview` - A memory efficient view of bytes - `mv = memoryview(b'Hello')`

![](Pasted%20image%2020251001114350.png)

### Dictionary Data Type for DevOps
We can use it on:
- Storing configuration settings
```python
config = {
  "hostname": "server1.example.com",
  "port": 8080,
  "username": "admin",
  "password": "secret"
}
print(config["hostname"])

#Output
#server1.example.com
```

- Environment variables
- Handling API responses. Used to parse JSON responses
```python
api_response = {
  "status": "success",
  "data": {
    "server": "192.168.1.1",
    "uptime": "24 hours"
  }
}
print(api_response["data"]["server"])
```

- Managing infrastructure.

## REGEX
For matching patterns in strings
Module: `re`
```python
re.match() # Matches at the beginning of the string
re.search() # Searches and returns the first occurrence
re.findall() # Return a list of all matches in the string
re.sub() # Replace matches with a new string
```

### Special Characters
Common special characters:

| Character | Description                  |
| --------- | ---------------------------- |
| `.`       | Any character except newline |
| `^`       | Start of a string            |
| `$`       | End of a string              |
| `*`       | 0 or more occurrences        |
| `+`       | 1 or more occurrences        |
| `[]`      | Character set                |
| `\|`      | Or                           |
| `\`       | Escape special character     |
| `\d`      | Digit                        |
| `\w`      | Word character               |
| `\s`      | Whitespace                   |
### Use Cases
- Parsing log files
- Validating input data
- Searching and replacing text in configuration files
- Extracting specific information

## KEYWORDS
Reserved words that have a predefined meaning and purpose in the language.
- They are reserved
- They are case sensitive
- Fixed set

### Control Flow Keywords

| Keyword                  | Meaning                                                    |
| ------------------------ | ---------------------------------------------------------- |
| if \| elif \| else       | Conditional                                                |
| for \| while             | Looping                                                    |
| break \| continue        | Control loop execution                                     |
| pass                     | Placeholder that does nothing                              |
| return                   | Exits a function and return a value                        |
| yield                    | Return a value in a generator function and pause its state |
| try \| except \| finally | Used for exception handling                                |
| raise                    | Used to raise an exception                                 |
### Data Type and Value Keywords

| Keyword          | Meaning                   |
| ---------------- | ------------------------- |
| True \| False    | Boolean                   |
| None             | Absence of a value (null) |
| and \| or \| not | Logical operators         |
### Function and Class Keywords

| Keywrod | Meaning                    |
| ------- | -------------------------- |
| def     | Define a function          |
| class   | Define a class             |
| lambda  | Create anonymous functions |
### Variable Scope and Namespace Keywords

| Keyword  | Meaning                                                              |
| -------- | -------------------------------------------------------------------- |
| global   | Declares a global variable inside a function                         |
| nonlocal | Refers to variables in the nearest enclosing scope, excluding global |
### Importing and Module Keywords

| Keyword        | Meaning                                                    |
| -------------- | ---------------------------------------------------------- |
| import \| from | Used to import modules or specific functions from a module |
| as             | Used to give an imported module or function an alias       |
### Object-Oriented Programming Keywords

| Keyword      | Meaning                                                  |
| ------------ | -------------------------------------------------------- |
| self         | Refers to the current instance of a class                |
| is           | Used to compare objects by reference                     |
| in \| not in | Used to check membership in sequences like lists or sets |

### Miscellaneous Keywords

| Keyword | Meaning                                                                             |
| ------- | ----------------------------------------------------------------------------------- |
| assert  | Used for debugging to test if a condition is true                                   |
| del     | Deletes an object or variable                                                       |
| with    | Simplifies exception handling and resource management <br>(When working with files) |
## VARIABLES
No need to specify the type of variable
Local and global refer to the scope in which a variable is defined and can be accessed

### Local Variables
Are defined inside a function and are only accesible within that function
In case of a variable with the same name locally and globally, the preferred options will be locally.
### Global Variables
Defined outside any function

## RETURN STATEMENT
Exit a function and send back a value to the caller
```python
def function_name(parameters):
  #Code
  return value

def add(a, b):
  return a + b

result = add(5, 3)
print(result) #Output: 8
```

## FUNCTIONS
Reusable block of code that performs a specific task
Help to organize and manage code
Can take parameters, perform operations and return outputs

```python
# Function with parameters
def greet(name, age):
    print(f"Hello, {name}. You are {age} years old.") # tells Python to evaluate any expressions inside curly braces {} and insert their values into the string.

# Calling the function with arguments
greet("Rodrigo", 38)
```

## MODULES
Files that contain Python code.
Help organizing and reusing code across different programs
- Code re usability
- Organization

### Types of Modules
- **Built-in Modules**
Math module: `import math`
```python
import math
result = math.sqrt(16)
print(result) #Output: 4.0
```
Examples:

| Built-in |
| -------- |
| math     |
| random   |
| datetime |
| os       |
| sys      |
| json     |
| re       |
| time     |


- **User-defined Modules**
First script
```python
# mymodule.py

def greet(name):
  return f"Hello {name}!"

def add(a,b):
  return a + b
```

Second Script (main)
```python
# main.py
import mymodule

greeting = mymodule.greet("Rodrigo")
sum_result = mymodule.add(5,7)

print(greeting)
print(sum_result)
```

## PACKAGES
Way of organizing related modules into a directory hierarchy
A **module** is a single Python file, while a **package** is a collection of modules that are stored in a directory
Also allow you to logically group modules that share a common functionality.

A **package** is essentially a directory that contains multiple modules and a special file named `__init__.py`. It distinguishes the directory as a Python package
```
my_package/
  __init__.py # Makes this directory a package
  module1.py # A Python module
  module2.py
  sub_package/
    __init__.py
    submodule1.py
```

A **subpackage** is a package that contains another packages.

### Advantages
- Modularity
- Namespace
- Re usability
- Maintainability

### \_\_Init\_\_.py
Example of a `__init__.py`
Considering that those are files we've already created
```python
# Import modules from the package we created
from .math_operations import add, subtract
from .string_operation import to_upper, to_lower
```

## COMMAND LINE ARGUMENTS
Enable users to pass arguments to a program when it is executed from the terminal.
Supply input data
E.g:
`python3 script.py arg1 arg2 arg3`

The `sys` module which includes a list for `sys.argv` for accessing command line arguments:
- `sys.argv[0]`: Is the script name
- `sys.argv[1]`: Represent the subsequent arguments

## OPERATORS
There are a variety of operators
**Arithmetic**

| Operator | Description    |
| -------- | -------------- |
| `+`      | Add            |
| `-`      | Subtract       |
| `*`      | Multiplication |
| `/`      | Division       |
| `%`      | Remainder      |
| `**`     | Exponentiation |
| `//`     | Floor Division |
**Comparison (Relational)**
The result is a boolean

| Operator | Description      |
| -------- | ---------------- |
| `==`     | Equal to         |
| `!=`     | Not equal to     |
| `>`      | greater than     |
| `<`      | Less than        |
| `>=`     | Greater or equal |
| `<=`     | Less or equal    |
**Logical**
Return a boolean

| Operator | Description                                        |
| -------- | -------------------------------------------------- |
| `and`    | Logical AND                                        |
| `or`     | Logical OR                                         |
| `not`    | Logical NOT<br>Reverse the response of an operator |
**Assignment**

| Operator | Description               | Example                      |
| -------- | ------------------------- | ---------------------------- |
| `=`      | Assign                    | `x = 5`                      |
| `+=`     | Add and Assign            | `x += 5` Same as `x = x + 5` |
| `-=`     | Subtract and Assign       | `x -=5` Same as `x = x - 5`  |
| `*=`     | Multiply and Assign       | `x *= 5`                     |
| `/=`     | Divide and Assign         | `x /= 5`                     |
| `%=`     | Modulus and Assign        | `x %= 5`                     |
| `**=`    | Exponentiation and Assign | `x **= 5`                    |
| `//=`    | Floor division and Assign | `x //= 5`                    |
**Membership**
Boolean return

| Operator | Description                                                   |
| -------- | ------------------------------------------------------------- |
| `in`     | Return True if a specified value is found in the sequence     |
| `not in` | Return True if a specified value is not found in the sequence |
```python
fruits = ["apple", "banana", "orange"]
print("banana" in fruits) #Output: True
print("grape" not in fruits) #Output: True
```

### Use of Operators on DevOps
Python plays a crucial role in automation, infrastructure as code and managing cloud services.
Often used in scripts to handle logic, data manipulation and interactions with various tools like AWS, SDKs, APIs and configuration management systems

## CONDITIONAL STATEMENTS
Making decisions in code base on certain conditions
`if else elif`
A conditions is True or False

```python
a = 10
b = 20

if a > b:
  print("a is greater than b")
elif b < a:
  print("a is less than b")
else:
  print("a is equal to b")
```

## LOOPS
Used to repeat a block of code multiple time.
- **for loop:** Iterates over a sequence (like a list, tuple, string or range)
```python
languages = ["Swift", "Python", "Go"]
for lang in languages:
  print(lang)
```

- **while loop:** We use it to repeat a block of code until a certain condition is met.
```python
number = 1
while numer <= 3:
  print(number)
  number += 1
```

## REAL-TIME USE CASES: LISTS AND EXCEPTION HANDLING

### The Use of Split
`split` can separate an input in a given way:
```python
import os
folders = input("Enter folder names:").split()
for i in folders:
    print(f"=== Listing folders: {i} ===")
    listed_files = os.listdir(i)
    for j in listed_files:
        print(j)
```

### The Use of Try Statement
To avoid getting big error messages on the screen we can use:
```python
import sys

try:
  a = int(sys.argv[1])
  b = int(sys.argv[2])
  div = a / b
  print(div)
except ZeroDivisionError: 
  print("Error: Division by zero is not allowed.")
```

## GITHUB USING PYTHON
Need to use the GitHub API
- Install Library: `PyGithub`
- Generate Personal Access Token
- Use `PyGithub` to Connect

Official Documentation can be found [Here](https://pygithub.readthedocs.io/en/stable/introduction.html)

### Python Virtual Environment - Pre Requisite
We will need to create a `Python venv`:
- Installing `python venv`
```bash
sudo apt install python3.12-venv
```
- Create the virtual environment on your folder:
```python
python3 -m venv venv
```
- You can now use `pip` to install Python libraries (e.g):
```python
# On the directory you created the venv
venv/bin/pip3.12 install PyGithub
```
- Also, you can start using your personal Python scripts:
```python
# On the directory you created the venv
venv/bin/python3.12 Section15-Github/pyGithub.py
```

### Clone a GitHub Repository Using Python
- Sub process module or use the `GitPython` library
- **Sub process Module:** This method runs the `git` command-line through Python. You need to have `git` installed.
- Use `subprocess.run()` to execute the `git` clone command
```python
import subprocess

# Define the URL
repo_url = "https://github.com/rodosilva/pythonForDevOps.git"

# Define the directory to clone into
clone_dir = "./testCloneRepo"

# Run the git clone command
subprocess.run(["git", "clone", repo_url, clone_dir])
```

- **Using GitPython Library**
First we need to install
```python
venv/bin/pip3.12 install GitPython
```

```python
import git

repo_url = "https://github.com/rodosilva/pythonForDevOps.git"
clone_dir = "/home/rodrigo/pythonForDevOps/Section15-Github/test-repo-clone"

# Cloning using gitPython Library
output = git.Repo.clone_from(repo_url, clone_dir)
print(output)
```

## BOTO3 PYTHON MODULE
`Boto3` is the Amazon Web Services (AWS) software Development Kit (SDK) for Python.
It allows developers to write software that makes use of services like Amazon S3, EC2, DynamoDB, etc.

**Steps**
- Install `Boto3`
- AWS Credentials Setup: `Boto3` uses your AWS credentials to connect to AWS.
	- Access Key ID
	- Secret Access Key
	- AWS Region
```bash
# First we need to unstall aws-cli and then execute
aws configure
```
### Install Boto3
```python
venv/bin/pip3.12 install boto3
```











