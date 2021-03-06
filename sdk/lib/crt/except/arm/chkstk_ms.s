/*
 * COPYRIGHT:         BSD - See COPYING.ARM in the top level directory
 * PROJECT:           CRT librariy
 * PURPOSE:           Implementation of _chkstk and _alloca_probe
 * PROGRAMMER:        Timo Kreuzer (timo.kreuzer@reactos.org)
 *                    Yuntian Zhang (yuntian.zh@gmail.com)
 */

/* INCLUDES ******************************************************************/

#include <kxarm.h>

/* CODE **********************************************************************/
    TEXTAREA

    LEAF_ENTRY ___chkstk_ms
    __assertfail
    bx lr
    LEAF_END __chkstk_ms

    LEAF_ENTRY __alloca_probe
    __assertfail
    bx lr
    LEAF_END __alloca_probe

    END
/* EOF */
