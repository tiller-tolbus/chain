::  %chain-ui
::
::    interface for the %chain testnet
::
/-  ch=chain, lg=ledger
/+  default-agent, dbug
/*  style-css  %css  /lib/style/css
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [fauceted-wallets=(set cord)]
+$  card  card:agent:gall
--
=|  state-0
=*  state  -
=<
%-  agent:dbug
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    cor   ~(. +> [bowl ~])
++  on-init
  =^  cards  state
    abet:init:cor
  [cards this]
++  on-save  !>(state)
++  on-load
  |=  =vase
  ^-  (quip card _this)
  =^  cards  state
    abet:(load:cor vase)
  [cards this]
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  =^  cards  state
    abet:(poke:cor mark vase)
  [cards this]
++  on-watch
  |=  =path
  `this
++  on-leave
  |=(path `..on-init)
++  on-peek
  |=(path ~)
++  on-arvo
  |=  [=wire =sign-arvo]
  [~ this]
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  =^  cards  state
    abet:(agent:cor wire sign)
  [cards this]
++  on-fail   on-fail:def
--
|_  [=bowl:gall cards=(list card)]
++  abet  [(flop cards) state]
++  cor   .
++  emit  |=(=card cor(cards [card cards]))
++  emil  |=(caz=(list card) cor(cards (welp (flop caz) cards)))
++  give  |=(=gift:agent:gall (emit %give gift))
++  init
  ^+  cor
  %-  emit
  [%pass /bind-site %arvo %e %connect [~ /apps/chain] dap.bowl]
++  load
  |=  =vase
  ^+  cor
  =/  old  !<(state-0 vase)
  =.  state  old
  cor
++  wallets
  .^((map cord @ux) %gx /(scot %p our.bowl)/chain/(scot %da now.bowl)/wallets/noun)
++  balance
  |=  addr=@ux
  ^-  (unit @ud)
  =+  .^(=balances:lg %gx /(scot %p our.bowl)/chain/(scot %da now.bowl)/balances/noun)
  (~(get by balances) addr)
++  transactions
  |=  addr=@ux
  ^-  (list txn-signed:ch)
  =/  r  .^((list txn-signed:ch) %gx /(scot %p our.bowl)/chain/(scot %da now.bowl)/transactions/[(scot %ux addr)]/noun)
  r
++  pending-transactions
  |=  addr=@ux
  ^-  (list txn-signed:ch)
  =/  r  .^((list txn-signed:ch) %gx /(scot %p our.bowl)/chain/(scot %da now.bowl)/transactions/[(scot %ux addr)]/pending/noun)
  r
++  agent
  |=  [=(pole knot) =sign:agent:gall]
  ^+  cor
  ?+  pole  ~|(bad-agent-wire+pole !!)
    [%send-tokens id=@ta ~]
      %-  emil
      %^    http-cards
          id.pole
        ~
      (crip (en-xml:html lazy-loader))
    [%faucet id=@ta ~]
      %-  emil
      %^    http-cards
          id.pole
        ~
      (crip (en-xml:html lazy-loader))
    [%new-wallet id=@ta ~]
      %-  emil
      %^    http-cards
          id.pole
        ~
      (crip (en-xml:html lazy-loader))
  ==
++  lazy-loader
  ;div
    =hx-get  ""
    =hx-trigger  "load"
    =hx-target  "main"
    =hx-select  "main"
    =hx-swap  "outerHTML"
    ; loading...
  ==
++  poke
  |=  [=mark =vase]
  ^+  cor
  ::
  ?>  =(mark %handle-http-request)
  ?>  =(our src):bowl
  =+  !<(req=(pair @ta inbound-request:eyre) vase)
  =/  purl  ::  parsed url with query params
    ::
    ^-  [pax=path pam=(map @t @t)]
    =+  %+  rash  url.request.q.req
        ;~  plug
            ;~(pfix fas (more fas smeg:de-purl:html))
            yque:de-purl:html
        ==
    [->+.- (molt +.-)]
  =/  body  ::  parsed form-encoded body
    ::
    %-  malt
    %+  fall
      %+  rush
        q:(fall body.request.q.req [p=0 q=''])
      yquy:de-purl:html
    ~
  =/  pams  ::  combined params from purl, body, & headers
    ::
    %-  ~(uni by (malt header-list.request.q.req))
    (~(uni by pam.purl) body)
  =/  route
    %-  (pole knot)
    :-  (crip (cass (trip method.request.q.req)))
    pax.purl
  ?+  route
    (emil (http-cards p.req ['X-Status' '400']~ 'Route not found'))
    ::
    [%get ~]
      %-  emil
      %^    http-cards
          p.req
        ~
      %-  html-cord
      %-  lift
      ;main.fc.g5
        ;+  part-header
        ;+  (part-wallet-links '')
        ;+  form-new-wallet
        ;+  part-footer
      ==
    [%get wallet-name=@t ~]
      =/  uddr  (~(get by wallets) wallet-name.route)
      %-  emil
      %^    http-cards
          p.req
        ~
      %-  html-cord
      %-  lift
      ;main.fc.g5
        ;+  part-header
        ;+  (part-wallet-links wallet-name.route)
        ;+  form-new-wallet
        ;*
          ?~  uddr
            ;=
              ;div: invalid wallet name
            ==
          =/  amount  (balance u.uddr)
          ;=
            ;+  (part-current-wallet wallet-name.route u.uddr)
            ;+  (form-send-tokens wallet-name.route)
            ;+  part-refresher
            ;+  ?~  amount
                  ;div#wallet-data.fc.g5
                    ;+  (form-faucet wallet-name.route)
                  ==
                ;div#wallet-data.fc.g5
                  ;+  (part-current-balance u.amount)
                  ;+  (part-txn-history u.uddr)
                ==
          ==
        ;+  part-footer
      ==
    [%post %new-wallet ~]
      =/  name  (~(got by pams) 'name')
      %-  emit
      [%pass /new-wallet/[p.req] %agent [our.bowl %chain] %poke %new-wallet !>(name)]
    [%post %faucet ~]
      =/  name  (~(got by pams) 'name')
      =.  fauceted-wallets  (~(put in fauceted-wallets) name)
      %-  emit
      [%pass /faucet/[p.req] %agent [our.bowl %chain] %poke %ask-faucet !>(name)]
    [%post %send-tokens wallet-name=@t ~]
      %-  emit
      =/  target  (slav %ux (~(got by pams) 'txn-target'))
      =/  amount  (slav %ud (~(got by pams) 'txn-amount'))
      :*
        %pass
        /send-tokens/[p.req]
        %agent
        [our.bowl %chain]
        %poke
        %send-tokens
        !>([wallet-name.route target amount])
      ==
    ::
  ==
++  http-cards
  |=  [id=@ta headers=(list [@t @t]) body=@t]
  =/  rath  [/http-response/[id]]~
  =/  page  (as-octs:mimes:html body)
  =/  status  (slav %ud (~(gut by (malt headers)) 'X-Status' '200'))
  :~
      [%give %fact rath %http-response-header !>([status headers])]
      [%give %fact rath %http-response-data !>(`page)]
      [%give %kick rath ~]
  ==
++  theme-dark
  ::
  %-  trip
  '''
  :root {
    --b0: #222;
    --b1: #333;
    --b2: #444;
    --b3: #555;
    --be: #752;
    --b-success: #351;
    --f1: #ccc;
    --f2: #999;
    --f3: #777;
    --f4: #555;
    --f-error: #531;
    --f-success: lightgreen;
    --link: lightblue;
    --hover:  115%;
  }
  '''
  ::
++  theme-light
  ::
  %-  trip
  '''
  :root {
    --f1: #333;
    --f2: #555;
    --f3: #777;
    --f4: #999;
    --f-error: #953;
    --f-success: #351;
    --b0: #eee;
    --b1: #ccc;
    --b2: #bbb;
    --b3: #888;
    --b-error: #ca8;
    --b-success: #8c8;
    --link: blue;
    --hover: 87%;
  }
  '''
  ::
++  theme-system
  ::
  """
  {theme-light}
  @media (prefers-color-scheme: dark) \{
  {theme-dark}
  }
  """
  ::
++  form-new-wallet
  ;div
    ;button.p2.wfc.border.br1.b1.hover
      =onclick  "$('#generator').toggleClass('hidden');$(this).toggleClass('toggled');"
      ; + new wallet
    ==
    ;form#generator.hidden.fr.br1.g1.p1
      =hx-post  "/apps/chain/new-wallet"
      =hx-swap  "outerHTML"
      =hx-target  "#wallet-links"
      =hx-confirm  "Create new wallet?"
      ;input.border.p2.br1.grow.s0
        =autocomplete  "off"
        =required  ""
        =type  "text"
        =name  "name"
        =placeholder  "wallet name"
        ;
      ==
      ;button.p2.border.b1.br1.wfc.s0
        ; create
      ==
    ==
  ==
  ::
++  part-current-wallet
  |=  [name=@t addr=@ux]
  ;div.fc
    ;h2.bold.s1.border-2.br1.p2: {(trip name)}
    ;+  (print-addr addr)
  ==
++  form-faucet
  |=  name=cord
  ?:  (~(has in fauceted-wallets) name)
    ;div.p4.border.fc.ac.jc.g4
      ; Loading up your wallet. Please be patient.
    ==
  ;div.p4.border.fc.ac.jc.g4
    ;div: no balance in the ledger
    ;form
      =hx-post  "/apps/chain/faucet"
      ;input.hidden
        =type  "text"
        =name  "name"
        =value  (trip name)
        ;
      ==
      ;button.p3.b1.br1.hover.border
        ; Initialize wallet
      ==
    ==
  ==
++  part-current-balance
  |=  amount=@ud
  ;div.fr.jc.jb.p4.br1.s1
    ;div: Balance
    ;div.mono.bold.s2: $TOKEN {(scow %ud amount)}
  ==
++  part-header
  ;header.p4.fr.ac.jb
    ;a/"/apps/chain"
      ;h1.s3: %chain
    ==
    ;span.border.p1.br1.fr.g3
      ;span.f3: test net v1
      ;span.bold: SECT
    ==
  ==
++  part-refresher
  ;div.loader
    =hx-get  ""
    =hx-trigger  "every 5s"
    =hx-swap  "outerHTML"
    =hx-target  "#wallet-data"
    =hx-select  "#wallet-data"
    ;span.loaded.mono(style "opacity: 0;"): loading
    ;span.loading.mono: loading
  ==
++  form-send-tokens
  |=  name=@t
  ;form.fc.g2.p3.border.br1
    =hx-post  "/apps/chain/send-tokens/{(trip name)}"
    ;label.fr.ac.g2
      ;span.mono: amount
      ;input.border.p1.br1.grow
        =type  "text"
        =name  "txn-amount"
        =required  ""
        =title  "@ud (12.312)"
        =autocomplete  "off"
        =pattern  (trip '[0-9]{1,3}(\\.[0-9]{3})*')
        =placeholder  "12.345"
        ;
      ==
    ==
    ;label.fr.ac.g2
      ;span.mono: target
      ;input.border.p1.br1.grow
        =type  "text"
        =name  "txn-target"
        =autocomplete  "off"
        =required  ""
        =title  "@ux (0x12.42a4)"
        =pattern  (trip '0x[a-z0-9]{1,4}(\\.[a-z0-9]{4})*')
        =placeholder  "0x1ab2"
        ;
      ==
    ==
    ;button.loader.p3.bold.s1.b1.br1.hover.wfc
      ;span.loaded: Send
      ;span.loading: ...
    ==
  ==
++  part-txn-history
  |=  addr=@ux
  ;div.fc.g4
    ;+
    =/  x  (lent (pending-transactions addr))
    ?:  =(0 x)  ;/("")
    ;div.f3.mono: {<x>} pending transactions
    ::
    ;*
    %+  turn
      %+  sort  (transactions addr)
      |=  [a=txn-signed:ch b=txn-signed:ch]
      (gth nonce.a nonce.b)
    |=  txn=txn-signed:ch
    =/  cmd
      %-  ledger-cmd:lg
      cmd.txn
    ;div.fc
      ;+  (print-addr target.cmd)
      ;div.fr.jb.as.border-2.br1.p2
        ;span.f2: #{(scow %ud nonce.txn)}
        ;span.mono: $TOKEN {(scow %ud amount.cmd)}
      ==
    ==
  ==
++  print-addr
  |=  addr=@ux
  ;div.break.p2.border-2.br1.b1
    ;span: {(scow %ux addr)}
  ==
++  part-wallet-links
  |=  current=cord
  ;div#wallet-links.fr.g2.ac.js
    ;*
    %+  turn  ~(tap by wallets)
    |=  [name=cord pub=@ux]
    =/  tog  ?:(=(name current) "toggled" "")
    ;a
      =class  "p2 br1 border b1 hover loader {tog}"
      =href  "/apps/chain/{(trip name)}"
      ;span.loaded: {(trip name)}
    ==
  ==
++  part-footer
  ;footer.p4.br1.prose.f3.tc
    =style  "margin-top: 100px; margin-bottom: 100px;"
    sponsored by [Chorus One](https://chorus.one)
    and [Red Horizon](https://redhorizon.com).
  ==
++  lift
  |=  in=manx
  =/  theme  %system
  =/  colors
    ?:  =(theme %light)  theme-light
    ?:  =(theme %dark)  theme-dark
    theme-system
    ::
  ;html
    ;head
      ;title: %chain - testnet
      ;script(src "https://code.jquery.com/jquery-3.7.1.js");
      ;script(src "https://unpkg.com/htmx.org@1.9.11");
      ;script(src "https://unpkg.com/htmx.org@1.9.11/dist/ext/response-targets.js");
      ;style: {(trip style-css)}
      ;style: {colors}
    ==
    ;body.mw-page.ma.p2.fc.g3
      ;+  in
    ==
  ==
++  html-cord
  |=  in=manx
  %-  crip
  %+  welp  "<!DOCTYPE html>"
  (en-xml:html in)
--
