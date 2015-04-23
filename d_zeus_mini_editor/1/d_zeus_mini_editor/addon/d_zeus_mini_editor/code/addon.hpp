#ifndef __ADDON_HPP_
#define __ADDON_HPP_


#define __ADDON_NAME__ d_zeus_mini_editor
#define __PREFIX__ "\xx\addons\d_zeus_mini_editor"
#define __PREFIXC__ "\xx\addons\d_zeus_mini_editor\code\"

#define FUNC(x) __ADDON_NAME__##_fncl_##x
#define CFUNC(x) __ADDON_NAME__##_fnc_##x

#define GVAR(x) __ADDON_NAME__##_var_##x


#define PV(x) private ['x']; x


#define LOCALIZE_PREFIX "STR_Addons__d_map_adv_markers__"
#define LOCALIZE(x) (localize (LOCALIZE_PREFIX + (x)))


#endif
