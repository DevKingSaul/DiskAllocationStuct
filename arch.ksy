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
  - id: block_list
    type: block_list
types:
  block_list: 
    seq:
      - id: block
        type: block_entry
        repeat: until
        repeat-until: _io.eof

  block_entry:
    seq:
      - id: block_size
        type: b15
      - id: is_allocated
        type: b1
        enum: enum_allocated
      - id: block
        type: block(is_allocated)

  block:
    params:
      - id: is_allocated
        type: u1
        enum: enum_allocated
    seq:
      - id: block
        type:
          switch-on: is_allocated
          cases:
            'enum_allocated::allocated': block_allocated
            'enum_allocated::free': block_free

  block_allocated:
    seq:
      - id: payload
        size: _io.size
        doc: Content of Pointer

  block_free:
    seq:
      - id: next_pointer
        type: u8le
        doc: Pointer to Next Free Block (0 if block is first)
      - id: prev_pointer
        type: u8le
        doc: Pointer to Previous Free Block (0 if block is last)
      - id: payload
        size: _io.size
        doc: Old Content of Pointer


enums:
  enum_allocated:
    1: allocated
    0: free