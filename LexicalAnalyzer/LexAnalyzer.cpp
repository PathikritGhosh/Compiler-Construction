# include <iostream>
# include <string>
using namespace std;

class LexAnalyzer
{
	public:
		string input_string;
		char c;
		int state;
		int pos;
		int size;
		char exp[100];
		int exp_size;


		LexAnalyzer(string str)
		{
			input_string=str;
			pos=0;
			state=12;
			exp_size=0;
			size=str.length();
		}

		char nextchar()
		{
			if(pos < size)
			{
				return input_string[pos++];
			}
			else
			{
				return ' ';
			}			
		}

		int check_dig(char temp)
		{
			if(temp=='0' || temp=='1' || temp=='2' || temp=='3' || temp=='4' || temp=='5' || temp=='6' || temp=='7' || temp=='8' || temp=='9')
			{
				return 1;
			}
			return 0;
		}

		void fail()
		{
			state=12;
			exp_size=0;
			cout<<"failed"<<endl;
		}

		void getToken()
		{
			while(1)
			{
				switch(state)
				{
					case 12:
						c=nextchar();
						if(check_dig(c))
						{
							state=13;
						}
						else
						{
							fail();
							return;
						}
						break;

					case 13:
						c=nextchar();
						if(check_dig(c))
						{
							state=13;
						}
						else if(c=='.')
						{
							state=14;
						}
						else if(c=='E')
						{
							state=16;
						}
						else
						{
							state=20;
						}
						break;

					case 14:
						c=nextchar();
						if(check_dig(c))
						{
							state=15;
						}
						else
						{
							fail();
							return;
						}
						break;

					case 15:
						c=nextchar();
						if(check_dig(c))
						{
							state=15;
						}
						else if(c=='E')
						{
							state=16;
						}
						else
						{
							state=21;
						}
						break;

					case 16:
						c=nextchar();
						if(c=='+' || c=='-')
						{
							exp[exp_size++]=c;
							state=17;
						}
						else if(check_dig(c))
						{
							state=18;
							exp[exp_size++]=c;
						}
						else
						{
							fail();
							return;
						}
						break;

					case 17:
						c=nextchar();
						if(check_dig(c))
						{
							state=18;
							exp[exp_size++]=c;
						}
						else
						{
							fail();
							return;
						}
						break;

					case 18:
						c=nextchar();
						if(check_dig(c))
						{
							state=18;
							exp[exp_size++]=c;
						}
						else
						{
							state=19;
						}
						break;

					case 19:
						cout<<"it has an exponent:"<<" ";
						for(int i=0;i<exp_size;++i)
						{
							cout<<exp[i];
						}
						cout<<endl;
						return;

					case 20:
						cout<<"Simple Integer"<<endl;
						return;

					case 21:
						cout<<"Real number"<<endl;
						return;		
				}
			}
		}
};

int main()
{
	string x;
	cin>>x;
	LexAnalyzer obj(x);
	obj.getToken();
}
