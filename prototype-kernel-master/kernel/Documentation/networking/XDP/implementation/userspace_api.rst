=============
Userspace API
=============

.. Warning::

   The userspace API specification should have been defined properly
   before code was accepted upstream.  Concerns have been raised about
   the current API upstream.  Users should expect this first API
   attempt will need adjustments; this cannot be considered a stable
   API yet.

   Most importantly, capabilities negotiation is missing;
   see :ref:`ref_prog_negotiation`.


Planning for API extension
==========================

The kernel documentation about `syscalls`_ have some good
considerations when designing an extendable API, and `Michael Kerrisk`_
also have some entertaining `API examples`_.

.. _syscalls:
   https://github.com/torvalds/linux/blob/master/Documentation/adding-syscalls.txt

.. _API examples: http://man7.org/conf/index.html

.. _Michael Kerrisk: http://man7.org/

.. Note:: With XDP_FLAGS in `commit 85de8576a0b1`_ (Daniel) prepared
          add/replace/delete logic for XDP programs.

.. _commit 85de8576a0b1: https://git.kernel.org/davem/net-next/c/85de8576a0b1

Struct xdp_prog
---------------

Currently (4.8-rc6) the XDP program is simply a bpf_prog pointer.
While this is good for simplicity, it limits extendability for
upcoming features.

Maybe we should introduce a new ``struct xdp_prog`` that can carry
information related to the XDP program.  Notice this approach does
not affect performance (tested and benchmarked), because the extra
dereference for the eBPF program only happens once per 64 packets in
the poll function.

The features that need this are:

* Multi-port TX:
  Need to know own port index and port lookup table.

* XDP program per RX queue:
  Need setup info about program type, global or specific, due to
  program-replacement semantics.

* Capabilities negotiation:
  Need to store information about features program wants to use,
  in order to validate this.

.. TODO:: How kernel devel works: This new ``struct xdp_prog``
   feature cannot go into the kernel before one of the three users of
   the struct is also implemented.  (Note, Jesper has implemented this
   struct change and has even benchmarked that it does not hurt
   performance).

XDP meta-data
-------------

The ``struct xdp_md`` carry XDP meta-data ("_md").  It is still
extensible because it has a internal BPF insn rewriter.

.. Daniel: extensibility wrt struct xdp_md, then it's done the same
   way as done for tc with 'shadow' struct __sk_buff. The concept of
   having this internal BPF insn rewriter is working quite well for
   this, and it is extendable with new meta data

.. Daniel: Wrt return codes we're flexible to add new ones once agreed upon

.. Daniel: The whole XDP config is done via netlink, nested in
   IFLA_XDP container, so it can be extended in future with other
   attrs, flags, etc, for setup and dumping.

.. include/uapi/linux/bpf.h should have been xdp.h


.. _`Troubleshooting and Monitoring`:

Troubleshooting and Monitoring
==============================

Users need the ability to both monitor and troubleshoot an XDP
program; particularly so in case of error events like :ref:`XDP_ABORTED`,
and in case an XDP program starts to return invalid and unsupported
action codes (caught by the :ref:`action fall-through`).

.. Note:: Daniel choose to implement this as tracepoints.
   See commit: a67edbf4fb6d ("bpf: add initial bpf tracepoints")
   https://git.kernel.org/davem/net-next/c/a67edbf4fb6d
   Scheduled for kernel 4.11.

.. Warning::

   The current (4.8-rc6) implementation is not optimal in this area.
   In the :ref:`action fall-through` case, the packet is dropped and a
   warning is generated **only once** about the invalid XDP program
   action code, by calling: bpf_warn_invalid_xdp_action(action_code);

The facilities and behavior need to be improved in this area.

Two options are on the table currently:

* Counters.

  Simply add counters to track these events.  This allows admins and
  monitoring tools to catch and count these events.  This does require
  standardizing these counters to help monitor tools.

* Tracepoints.

  Another option is adding tracepoints to these situations.  These are
  much more flexible than counters.  The downside is that these error
  events might never be caught, if the tracepoint isn't active.

An important design consideration is that the monitor facility must
not be too expensive to execute, even though events like :ref:`XDP_ABORTED`
and :ref:`action fall-through` should normally be very rare.  This is
because an external attacker (given the DDoS uses-cases) might find a
way to trigger these events, which would then serve as an attack
vector against XDP.
