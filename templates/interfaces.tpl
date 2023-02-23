auto ${NIC}
iface ${NIC} inet static
    %{ if IP_ADDRESS != "null" }address ${IP_ADDRESS}%{ endif }
    %{ if GW_ADDRESS != "null" }gateway ${GW_ADDRESS}%{ endif }

