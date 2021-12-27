"" ************************************************************************** ""
""                                                                            ""
""                                                        :::      ::::::::   ""
""   header42.vim                                       :+:      :+:    :+:   ""
""                                                    +:+ +:+         +:+     ""
""   By: vgoncalv <vgoncalv@student.42sp.org.br>    +#+  +:+       +#+        ""
""                                                +#+#+#+#+#+   +#+           ""
""   Created: 2021/12/26 23:57:03 by vgoncalv          #+#    #+#             ""
""   Updated: 2021/12/27 07:24:45 by vgoncalv         ###   ########.fr       ""
""                                                                            ""
"" ************************************************************************** ""

function header42#Highlight() abort
	if luaeval("require'header42.header'.is_present()")
		lua require'header42.highlight'.highlight()
	endif
endfunction

command! Stdheader lua require'header42'.Stdheader()
