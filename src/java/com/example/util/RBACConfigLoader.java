package com.example.util;

import org.w3c.dom.*;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.util.*;

public class RBACConfigLoader {

    private static final String CONFIG_PATH = "/WEB-INF/rbac_config.xml";

    public static Map<String, List<String>> loadRBACConfig(String realPath) {
        Map<String, List<String>> rbacMap = new HashMap<>();

        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document document = builder.parse(realPath + CONFIG_PATH);

            NodeList roleNodes = document.getElementsByTagName("role");
            for (int i = 0; i < roleNodes.getLength(); i++) {
                Element roleElement = (Element) roleNodes.item(i);
                String roleName = roleElement.getAttribute("name");
                List<String> permissions = new ArrayList<>();

                NodeList permissionNodes = roleElement.getElementsByTagName("permission");
                for (int j = 0; j < permissionNodes.getLength(); j++) {
                    permissions.add(permissionNodes.item(j).getTextContent());
                }

                rbacMap.put(roleName, permissions);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return rbacMap;
    }
}
