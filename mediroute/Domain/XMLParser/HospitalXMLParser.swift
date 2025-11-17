//
//  HospitalXMLParser.swift
//  mediroute
//
//  Created by 황진우 on 11/16/25.
//
import Foundation

class HospitalXMLParser: NSObject, XMLParserDelegate {
    private var hospitals: [Hospital] = []
    private var currentElement = ""
    
    private var name = ""
    private var address = ""
    private var phone = ""
    private var xPos = ""
    private var yPos = ""

    func parse(data: Data) -> [Hospital] {
        var xmlString = String(data: data, encoding: .utf8) ?? ""
        xmlString = xmlString.replacingOccurrences(of: "<script/>", with: "")
        let cleanedData = Data(xmlString.utf8)

        let parser = XMLParser(data: cleanedData)
        parser.delegate = self
        parser.parse()
        return hospitals
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "item" {
            name = ""
            address = ""
            phone = ""
            xPos = ""
            yPos = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let value = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty else { return }

        switch currentElement {
        case "dutyName": name += value
        case "dutyAddr": address += value
        case "dutyTel1": phone += value
        case "wgs84Lon": xPos += value
        case "wgs84Lat": yPos += value
        default: break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let hospital = Hospital(
                hospitalName: name,
                hospitalAddr: address,
                hospitalTel: phone,
                xPos: xPos,
                yPos: yPos
            )
            hospitals.append(hospital)
        }
    }
}
