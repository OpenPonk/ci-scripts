PharoLightTheme beCurrent.
Smalltalk at: #OPUmlClassEditorPlugin ifPresent: [ :plugin | plugin withAllSubclasses flatCollectAsSet: #defaultProfiles ].
Smalltalk at: #StWelcomeBrowser ifPresent: [:browser | browser allInstances do: [ :each | each withWindowDo: #close ] ].
PolymorphSystemSettings setDesktopLogoWith: OPCoreIcons logo asMorph.
