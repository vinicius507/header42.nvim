"" ************************************************************************** ""
""                                                                            ""
""                                                        :::      ::::::::   ""
""   header42.vim                                       :+:      :+:    :+:   ""
""                                                    +:+ +:+         +:+     ""
""   By: vgoncalv <vgoncalv@student.42sp.org.br>    +#+  +:+       +#+        ""
""                                                +#+#+#+#+#+   +#+           ""
""   Created: 2021/12/26 23:57:03 by vgoncalv          #+#    #+#             ""
""   Updated: 2021/12/27 00:02:38 by vgoncalv         ###   ########.fr       ""
""                                                                            ""
"" ************************************************************************** ""

function header42#Insert() abort
	if luaeval("require'header42.header'.is_present()")
		lua require'header42.header'.update()
	else
		lua require'header42.header'.insert()
	endif
endfunction

function header42#Update() abort
	if luaeval("require'header42.header'.is_present()")
		lua require'header42.header'.update()
	endif
endfunction

command! Stdheader call header42#Insert()

augroup header42
	autocmd!
	autocmd BufWritePost * call header42#Update()
augroup end
