meta:
  id: file
  title: File Allocation Pointer
  endian: be
seq:
  - id: head_pointer
    type: u8be
    doc: The first free block. (0 if none are free)
  - id: end_pointer
    type: u8be
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

  block_info:
    seq:
      - id: block_info
        type: u2be
    instances:
      block_size:
        value: (block_info & 0b1111111111111110) >> 1
      is_allocated:
        value:  block_info & 0b00000000000000001
        enum: enum_allocated

  block_entry:
    seq:
      - id: block_header
        type: block_info
      - id: block
        type: block(block_header.is_allocated)
      - id: block_footer
        type: block_info

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
        size: _parent._parent.block_header.block_size
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
        size: _parent._parent.block_header.block_size - 16
        doc: Old Content of Pointer


enums:
  enum_allocated:
    1: allocated
    0: free
