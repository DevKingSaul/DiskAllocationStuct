meta:
  id: diskalloc
  title: File Allocation Pointer
  endian: le
seq:
  - id: head_pointer
    type: u8le
    doc: The first free block. (0 if none are free)
  - id: end_pointer
    type: u8le
    doc: The last free block.
  - id: block
    type: block_entry
    repeat: until
    repeat-until: _io.eof
    types:
      block_entry:
        seq:
          - id: block_size
            type: b31
          - id: is_allocated
            type: b1
