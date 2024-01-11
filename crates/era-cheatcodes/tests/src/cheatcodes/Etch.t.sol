// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2 as console} from "../../lib/forge-std/src/Test.sol";
import {Constants} from "./Constants.sol";

contract CheatcodeEtchTest is Test {
    address constant TEST_ADDRESS = 0x6Eb28604685b1F182dAB800A1Bfa4BaFdBA8a79a;
    bytes constant GREETER_CODE =
        hex"00050000000000020000000003010019000000600330027000000060033001970000000102200190000000950000c13d000000040230008c000000e00000413d000000000201043b0000006702200197000000680220009c000000e00000c13d0000000002000416000000000202004b000000e00000c13d000000040230008a000000200220008c000000e00000413d0000000402100370000000000502043b000000640250009c000000e00000213d00000023025000390000006904000041000000000632004b000000000600001900000000060480190000006902200197000000000702004b0000000004008019000000690220009c00000000020600190000000002046019000000000202004b000000e00000c13d0000000406500039000000000261034f000000000402043b000000640240009c0000009d0000213d0000001f07400039000000200200008a000000000727016f000000bf07700039000000000727016f0000006a087000410000006b0880009c0000009d0000413d000000400070043f000000800040043f00000000054500190000002405500039000000000335004b000000e00000213d0000002003600039000000000131034f0000001f0340018f0000000505400272000000440000613d00000000060000190000000507600210000000000871034f000000000808043b000000a00770003900000000008704350000000106600039000000000756004b0000003c0000413d000000000603004b000000530000613d0000000505500210000000000151034f0000000303300210000000a005500039000000000605043300000000063601cf000000000636022f000000000101043b0000010003300089000000000131022f00000000013101cf000000000161019f0000000000150435000000a0014000390000000000010435000000800100043d000000640310009c0000009d0000213d000000000400041a000000010340019000000001034002700000007f0330618f0000001f0530008c00000000050000190000000105002039000000000454013f0000000104400190000000fc0000c13d000000200430008c000000740000413d0000001f0410003900000005044002700000006c044000410000006c05000041000000200610008c000000000405401900000000000004350000001f0330003900000005033002700000006c03300041000000000534004b000000740000813d000000000004041b0000000104400039000000000534004b000000700000413d0000001f0310008c000001000000a13d0000000003210170000000a0040000390000006c020000410000000000000435000000880000613d0000006c0200004100000020060000390000000004000019000000000506001900000080065000390000000006060433000000000062041b000000200650003900000001022000390000002004400039000000000734004b0000007e0000413d000000a004500039000000000313004b000000920000813d0000000303100210000000f80330018f000000010500008a000000000335022f000000000353013f0000000004040433000000000334016f000000000032041b000000010200003900000001031002100000010a0000013d0000008002000039000000400020043f0000000002000416000000000202004b000000e00000c13d0000006102300041000000620220009c000000a30000213d0000006d0100004100000000001004350000004101000039000000040010043f0000006e010000410000017b000104300000009f023000390000006302200197000000400020043f0000001f0230018f0000000504300272000000b20000613d00000000050000190000000506500210000000000761034f000000000707043b000000800660003900000000007604350000000105500039000000000645004b000000aa0000413d000000000502004b000000c10000613d0000000504400210000000000141034f00000003022002100000008004400039000000000504043300000000052501cf000000000525022f000000000101043b0000010002200089000000000121022f00000000012101cf000000000151019f0000000000140435000000200130008c000000e00000413d000000800400043d000000640140009c000000e00000213d00000080033000390000009f01400039000000000131004b000000e00000813d00000080024000390000000001020433000000640510009c0000009d0000213d0000003f05100039000000200900008a000000000595016f000000400800043d0000000005580019000000000685004b00000000060000190000000106004039000000640750009c0000009d0000213d00000001066001900000009d0000c13d000000400050043f00000000061804360000000004140019000000a004400039000000000334004b000000e20000a13d00000000010000190000017b00010430000000000301004b000000ec0000613d000000000300001900000000046300190000002003300039000000000523001900000000050504330000000000540435000000000413004b000000e50000413d000000000116001900000000000104350000000004080433000000640140009c0000009d0000213d000000000100041a000000010210019000000001011002700000007f0310018f000000000301c0190000001f0130008c00000000010000190000000101002039000000010110018f000000000112004b0000010e0000613d0000006d0100004100000000001004350000002201000039000000a00000013d000000000201004b0000000002000019000001040000613d000000a00200043d0000000303100210000000010400008a000000000334022f000000000343013f000000000332016f0000000102100210000000000123019f000000000010041b00000000010000190000017a0001042e000000200130008c000001340000413d000100000003001d000300000004001d000000000000043500000060010000410000000002000414000000600320009c0000000001024019000000c00110021000000065011001c70000801002000039000500000008001d000400000009001d000200000006001d017901740000040f0000000206000029000000040900002900000005080000290000000102200190000000e00000613d00000003040000290000001f024000390000000502200270000000200340008c0000000002004019000000000301043b00000001010000290000001f01100039000000050110027000000000011300190000000002230019000000000312004b000001340000813d000000000002041b0000000102200039000000000312004b000001300000413d0000001f0140008c000001630000a13d000300000004001d000000000000043500000060010000410000000002000414000000600320009c0000000001024019000000c00110021000000065011001c70000801002000039000500000008001d000400000009001d017901740000040f000000040300002900000005060000290000000102200190000000e00000613d000000030700002900000000033701700000002002000039000000000101043b000001550000613d0000002002000039000000000400001900000000056200190000000005050433000000000051041b000000200220003900000001011000390000002004400039000000000534004b0000014d0000413d000000000373004b000001600000813d0000000303700210000000f80330018f000000010400008a000000000334022f000000000343013f00000000026200190000000002020433000000000232016f000000000021041b000000010100003900000001027002100000016d0000013d000000000104004b0000000001000019000001670000613d00000000010604330000000302400210000000010300008a000000000223022f000000000232013f000000000221016f0000000101400210000000000112019f000000000010041b00000020010000390000010000100443000001200000044300000066010000410000017a0001042e00000177002104230000000102000039000000000001042d0000000002000019000000000001042d00000179000004320000017a0001042e0000017b00010430000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000009fffffffffffffffffffffffffffffffffffffffffffffffff000000000000007f00000000000000000000000000000000000000000000000000000001ffffffe0000000000000000000000000000000000000000000000000ffffffffffffffff02000000000000000000000000000000000000200000000000000000000000000000000200000000000000000000000000000040000001000000000000000000ffffffff00000000000000000000000000000000000000000000000000000000a4136862000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff0000000000000080290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e5634e487b71000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000024000000000000000000000000000000000000000000000000000000000000000000000000000000000000000051358bfd296e885430dddecb908ce82d20e6832374027da7514aebac3689d51f";

    function testEtch() public {
        vm.etch(TEST_ADDRESS, GREETER_CODE);
    }
}
