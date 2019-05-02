.. (comment) The references above each section is used for doing
   cross-referencing from arbitrary locations in any document.
   I know the markup looks a little wierd.
   Used like :ref:`XDP_DROP`
   Online: http://www.sphinx-doc.org/en/stable/markup/inline.html#role-ref

===========
XDP actions
===========

.. _XDP_PASS:

XDP_PASS
========

XDP_PASS means the XDP program chose to pass the packet to the normal
network stack for processing.  Note that the XDP program is allowed to
have modified the packet-data.


.. _XDP_DROP:

XDP_DROP
========

XDP_DROP is perhaps the simplest and fastest action.  It simply
instructs the driver to drop the packet.  Given this action happens at
the earliest RX stage in the driver, dropping a packet simply implies
recycling it back-into the RX ring queue it just "arrived" on.  There
is simply no faster way to drop a packet.  This comes close to a
driver hardware test feature.


.. _XDP_TX:

XDP_TX
======

The XDP_TX action result in TX bouncing the received packet-page back
out the same NIC it arrived on.  This is usually combined with
modifying the packet contents before returning action XDP_TX.

The XDP_TX feature can be used for implementing a special kind of
one-legged Load-Balancer as described in
:doc:`../use-cases/xdp_use_case_load_balancer`.


.. _XDP_ABORTED:

XDP_ABORTED
===========

The XDP_ABORTED action is not something a functional program should
ever use as a return code.  This return code is something an ``eBPF``
program returns in case of an eBPF program error, e.g. division by
zero.  For this reason XDP_ABORTED will always be the value zero.

This XDP_ABORTED action results in the packet getting dropped.

For how to troubleshoot this kind of unlikely error event, see the
section :ref:`Troubleshooting and Monitoring`.


.. _`action fall-through`:

Fall-through
============

There must also be a fall-through ``default:`` case, which is hit if
the program returns an unknown action code (e.g. future action this
driver does not support).

These unknown return codes will result in packet drop.

See the section :ref:`Troubleshooting and Monitoring` for how to catch
these kind of situations.


Code example
------------

The basic action code block the driver use, is simply a switch-case
statement as below.

.. code-block:: c

	switch (action) {
		case XDP_PASS:
			break; /* Normal netstack handling */
		case XDP_TX:
			if (driver_xmit(dev, page, length) == NETDEV_TX_OK)
				goto consumed;
			goto xdp_drop; /* Drop on xmit failure */
		default:
			bpf_warn_invalid_xdp_action(action);
		case XDP_ABORTED:
		case XDP_DROP:
	xdp_drop:
			if (driver_recycle(page, ring))
				goto consumed;
			goto next; /* Drop */
		}
	}

.. Warning:: It is still undecided whether the ``action`` code needs
             to be partitioned into opcodes, with some of the upper
             bits used as values for the given opcode. This can be
             extended later.
