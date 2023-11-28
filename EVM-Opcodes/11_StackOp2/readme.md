# 堆栈指令2

之前，我们介绍了堆栈指令中的`PUSH`和`POP`，这一讲我们将介绍另外两个指令：`DUP`和`SWAP`。

## DUP

在EVM中，`DUP`是一系列的指令，总共有16个，从`DUP1`到`DUP16`，操作码范围为`0x80`到`0x8F`，gas消耗均为3。这些指令用于复制（Duplicate）堆栈上的指定元素（根据指令的序号）到堆栈顶部。例如，`DUP1`复制栈顶元素，`DUP2`复制距离栈顶的第二个元素，以此类推。

我们可以在极简EVM中增加对`DUP`指令的支持：

```python
DUP1 = 0x80
DUP16 = 0x8F

def dup(self, position):
    if len(self.stack) < position:
        raise Exception('Stack underflow')
    value = self.stack[-position]
    self.stack.append(value)

def run(self):
    while self.pc < len(self.code):
        op = self.next_instruction()

        # ... 其他指令的实现 ...

        elif DUP1 <= op <= DUP16: # 如果是DUP1-DUP16
            position = op - DUP1 + 1
            self.dup(position)
```

现在，我们可以尝试运行一个包含`DUP1`指令的字节码：`0x6001600280`（PUSH1 1 PUSH1 2 DUP1）。这个字节码将`1`和`2`推入堆栈，然后进行`DUP1`复制栈顶元素（2），堆栈最后会变为[1, 2, 2]。

```python
# DUP1
code = b"\x60\x01\x60\x02\x80"
evm = EVM(code)
evm.run()
print(evm.stack)  
# output: [1, 2, 2]
```

## SWAP

`SWAP`指令用于交换堆栈顶部的两个元素。与`DUP`类似，`SWAP`也是一系列的指令，从`SWAP1`到`SWAP16`共16个，操作码范围为`0x90`到`0x9F`，gas消耗均为3。`SWAP1`交换堆栈的顶部和次顶部的元素，`SWAP2`交换顶部和第三个元素，以此类推。

让我们在极简EVM中增加对`SWAP`指令的支持：

```python
SWAP1 = 0x90
SWAP16 = 0x9F

def swap(self, position):
    if len(self.stack) < position + 1:
        raise Exception('Stack underflow')
    idx1, idx2 = -1, -position - 1
    self.stack[idx1], self.stack[idx2] = self.stack[idx2], self.stack[idx1]

def run(self):
    while self.pc < len(self.code):
        op = self.next_instruction()

        # ... 其他指令的实现 ...

        elif SWAP1 <= op <= SWAP16: # 如果是SWAP1-SWAP16
            position = op - SWAP1 + 1
            self.swap(position)
```

现在，我们可以尝试运行一个包含`SWAP1`指令的字节码：`0x6001600290`（PUSH1 1 PUSH1 2 SWAP1）。这个字节码将`1`和`2`推入堆栈，然后进行`SWAP1`交换这两个元素，堆栈最后会变为[2, 1]。

```python
# SWAP1
code = b"\x60\x01\x60\x02\x90"
evm = EVM(code)
evm.run()
print(evm.stack)  
# output: [2, 1]
```
