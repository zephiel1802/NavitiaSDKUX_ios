import Foundation

class Modes {
    func getModeIcon(section: Section?) -> String {
        switch section!.type! {
        case "public_transport": return getPhysicalMode(section: section).lowercased()
        case "transfer": return section!.transferType!
        case "waiting": return section!.type!
        case "street_network": return getStreetNetworkMode(section: section).lowercased()
        default: return section!.mode!
        }
    }

    func getPhysicalMode(section: Section?) -> String {
        let id = getPhysicalModeId(section: section)
        var modeData = id.characters.split(separator: ":").map(String.init)
        return modeData[1]
    }
    
    private func getStreetNetworkMode(section: Section?) -> String {
        if section?.mode == "bike" {
            if ((section?.from?.poi?.properties!["network"]) != nil) {
                return "bss"
            }
        }
        return section!.mode!
    }

    private func getPhysicalModeId(section: Section?) -> String {
        for link in section!.links! {
            if link.type == "physical_mode" {
                return link.id!
            }
        }
        return "<not_found>"
    }
}
