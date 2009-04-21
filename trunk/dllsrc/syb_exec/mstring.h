#ifndef __MSTRING_H__
#define __MSTRING_H__
#define __MSTRING_H__ALLOC 2048

#include <tchar.h>

class mstring {
	private:
		//--- member variables

		TCHAR* ptr;
		long allocated;
		long length;
		
		void init(){
			allocated=0;
			length=0;
			ptr = NULL;
			//printf("init\n");
		}
		//! Reallocate the array, make it bigger or smaler
		void realloc(long new_size) {
			//printf("realloc > %i\n",new_size);
			if(new_size>allocated){
				TCHAR* old_ptr = ptr;
				new_size/=__MSTRING_H__ALLOC;
				new_size++;
				new_size*=__MSTRING_H__ALLOC;
				ptr=new TCHAR[new_size];
				if(old_ptr)	{
					_tcscpy(ptr,old_ptr);
					delete [] old_ptr;
				}else{
					ptr[0]=0;
				}
				allocated=new_size;
				//printf("realloc >> %i\n",new_size);
			}
		}
	public:
		//! Default constructor
		mstring(){
			init();
		}

		//! Constructor
		mstring(TCHAR*c){
			init();
			append(c);
		}


		//! destructor
		~mstring() {
			if(ptr)delete [] ptr;
			//printf("destroy\n");
		}
		
		TCHAR * c_str(){
			return ptr;
		}
		
		TCHAR charAt(long i){
			if(i>length || i<0 || length==0)return 0;
			return ptr[i];
		}

		void append(TCHAR * c){
			if(!c)return;
			long i=_tcslen(c);
			realloc(length+i+1);
			_tcscpy(ptr+length,c);
			length+=i;
			//printf("append > %s<<\n",ptr);
		}
		
		long len(){
			return length;
		}

};



#endif

