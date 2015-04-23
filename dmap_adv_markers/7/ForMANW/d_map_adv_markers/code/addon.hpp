#ifndef __ADDON_HPP_
#define __ADDON_HPP_


#define __ADDON_NAME__ d_map_adv_markers
#define __BASENAME__ Addons__##__ADDON_NAME__
#define __PREFIX__ "\xx\addons\d_map_adv_markers"
#define __PREFIXC__ "\xx\addons\d_map_adv_markers\code\"

#define FUNC(x) fnc_##__BASENAME__##_##x
#define CFUNC(x) __ADDON_NAME__##_fnc_##x

#define GVAR(x) __BASENAME__##_##x


#define PV(x) private ['x']; x




#endif
