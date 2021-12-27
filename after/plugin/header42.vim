"" ************************************************************************** ""
""                                                                            ""
""                                                        :::      ::::::::   ""
""   header42.vim                                       :+:      :+:    :+:   ""
""                                                    +:+ +:+         +:+     ""
""   By: vgoncalv <vgoncalv@student.42sp.org.br>    +#+  +:+       +#+        ""
""                                                +#+#+#+#+#+   +#+           ""
""   Created: 2021/12/27 03:23:40 by vgoncalv          #+#    #+#             ""
""   Updated: 2021/12/27 07:27:47 by vgoncalv         ###   ########.fr       ""
""                                                                            ""
"" ************************************************************************** ""

hi def link Header42 Comment
hi def link Header42Filename PreProc
hi def link Header42Section Header42
hi def link Header42Keyword Header42
hi def link Header42Title PreProc
hi def link Header42Author Constant
hi def link Header42Mail Keyword
hi def link Header42Date Constant
hi def link Header42Logo PreProc

augroup header42
	autocmd!
	autocmd BufRead * call header42#Highlight()
	autocmd BufWritePost * lua require'header42.header'.update()
augroup end
