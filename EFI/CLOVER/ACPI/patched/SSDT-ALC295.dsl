DefinitionBlock ("", "SSDT", 1, "hack", "ALC295", 0x00000000)
{
    External (_SB_.PCI0.HDEF, DeviceObj)    // (from opcode)

    Name (_SB.PCI0.HDEF.RMCF, Package (0x02)
    {
        "CodecCommander",
        Package (0x02)
        {
            "Custom Commands",
            Package (0x0B)
            {
                Package (0x00) {},
                
                Package (0x08)
                {
                    "Command",
                    Buffer (0x04)
                    {
                         0x00, 0x27, 0x05, 0x00                       
                    },

                    "On Init",
                    ">y",
                    "On Sleep",
                    ">y",
                    "On Wake",
                    ">y"
                },

                Package (0x08)
                {
                    "Command",
                    Buffer (0x04)
                    {
                         0x00, 0x37, 0x05, 0x33                       
                    },

                    "On Init",
                    ">y",
                    "On Sleep",
                    ">y",
                    "On Wake",
                    ">y"
                },

                Package (0x08)
                {
                    "Command",
                    Buffer (0x04)
                    {
                         0x01, 0x47, 0x05, 0x00                       
                    },

                    "On Init",
                    ">y",
                    "On Sleep",
                    ">y",
                    "On Wake",
                    ">y"
                },

                Package (0x08)
                {
                    "Command",
                    Buffer (0x04)
                    {
                         0x02, 0x17, 0x05, 0x33                       
                    },

                    "On Init",
                    ">y",
                    "On Sleep",
                    ">y",
                    "On Wake",
                    ">y"
                },

                Package (0x08)
                {
                    "Command",
                    Buffer (0x04)
                    {
                         0x01, 0x97, 0x07, 0x20                       
                    },

                    "On Init",
                    ">y",
                    "On Sleep",
                    ">y",
                    "On Wake",
                    ">y"
                },

                Package (0x08)
                {
                    "Command",
                    Buffer (0x04)
                    {
                         0x02, 0x17, 0x09, 0x00                       
                    },

                    "On Init",
                    ">y",
                    "On Sleep",
                    ">y",
                    "On Wake",
                    ">y"
                },

                Package (0x08)
                {
                    "Command",
                    Buffer (0x04)
                    {
                         0x00, 0x23, 0x00, 0x57                       
                    },

                    "On Init",
                    ">y",
                    "On Sleep",
                    ">y",
                    "On Wake",
                    ">y"
                },

                Package (0x08)
                {
                    "Command",
                    Buffer (0x04)
                    {
                         0x01, 0x43, 0x00, 0x00                       
                    },

                    "On Init",
                    ">y",
                    "On Sleep",
                    ">y",
                    "On Wake",
                    ">y"
                },

                Package (0x08)
                {
                    "Command",
                    Buffer (0x04)
                    {
                         0x02, 0x13, 0x00, 0x80                       
                    },

                    "On Init",
                    ">y",
                    "On Sleep",
                    ">y",
                    "On Wake",
                    ">y"
                }
            }
        }
    })
}