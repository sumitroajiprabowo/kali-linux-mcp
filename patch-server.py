"""Patch upstream MCP server bug: CommandExecutor rejects list commands."""
with open("/usr/share/mcp-kali-server/server.py", "r") as f:
    code = f.read()

# Fix 1: Convert list to string instead of raising error
old = '        if not isinstance(self.command, str):\n            raise ValueError(f"CommandExecutor expects a string, but got {type(self.command).__name__}")'
new = '        if isinstance(self.command, list):\n            self.command = " ".join(self.command)'
code = code.replace(old, new)

# Fix 2: Recalculate use_shell after list-to-string conversion
old2 = '        cmd_args = shlex.split(self.command)'
new2 = '        self.use_shell = isinstance(self.command, str)\n        cmd_args = shlex.split(self.command)'
code = code.replace(old2, new2)

with open("/usr/share/mcp-kali-server/server.py", "w") as f:
    f.write(code)
