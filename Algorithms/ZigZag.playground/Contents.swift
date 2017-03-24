//: Playground - noun: a place where people can play

import UIKit

var str = "PAYPALISHIRING" // "PAHNAPLSIIGYIR"

extension String {
    func index(_ i: Int) -> Index {
        return index(startIndex, offsetBy: i)
    }
    
    subscript (i: Int) -> Character {
        return self[index(i)]
    }
}

func convert(_ s: String, _ numRows: Int) -> String {
    var letters = Array(repeating: [Character](), count: numRows) // [[Character]]
    var i = 0
    while i < s.characters.count {
        for j in 0..<numRows where i < s.characters.count { // down bound
            letters[j].append(s[i])
            i += 1
        }
        if numRows > 1 {
            for j in (1..<numRows - 1).reversed() where i < s.characters.count { // up bound diagonal
                letters[j].append(s[i])
                i += 1
            }
        }
    }
    return letters.flatMap { String($0) }.joined()
}

convert(str, 3)
convert("A", 1)
convert("ssartgskkqomcjiaxzgnhfljxmsudswvlxogfgsqygebsmbpoiexpqhmebhhufehespkahcyngbhudzindgevprzqaikfotkiiwkpyjfgmoapnjetrjogcqweajjrevzntkervlzhaaznlficqziupgyrrkiwfkjzwpsrbsabszqfhzhxarspzqirctpifajbpbusvutpwmudnbcnuweuponrhczmckntmjmjehzattfixjvrgbnvqamxcomgybcmlowpvvrrqyznhxfnyskotzoxnagnbicoyafvvymnwobglgtlagcvfqvssbhvljkjjpegotukhvsudohdujbzbwttxcpkmztxqzeesarbxjxaxfftqgsscnlbqclcbebsgfyyhpcebzgagmuxuopxccasfmwisxcyfbzmsdtvezwlnqiiezhibhaivyroytoduprpukkzmgkzyuhdtolwyoftmwjmpapmrjbmvllhsxhsrqvkhjgfznynjkabkrnbaonybafvxooohlaoujtvwtjifjjpawtdmgbpjilgzbxgmxujipehkppqyyhbwaekjhzspmaqpxwexsnfjtmujbmhbvkxwqjhxlbpzbfpzctwwibgbqcmrqwvlgsjxesuptlqvrhuvasrktzmldydtwyhdsqaylwpekgzbnvyqnrajrouupxqlxxospqqapgfzmgcbccrptsymitjxszjswzknqaqhgviudkwfmpxhjvusqdpjcadaanpsnfzwchsgtqlhikorgijylbjpbmrdzhxpmwnpffvayihgtyxbgjzumllpxdtxkqowpbnwikzgtioogoppxqljbwybbtanmomdrzzzkyifjytpmkejcrueovhrohfavrdmqfncfxhowcgimmupeovulclalqcghiuaphcwfkndmtlbfhsjypdjtrlehokrygrpnvluhyxutlxzspkqgqczhndqdphbvaskwghfeezyr", 155)
