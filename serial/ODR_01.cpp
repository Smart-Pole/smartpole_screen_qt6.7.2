#include "ODR_01.h"
#include "serial_interface.h"

#define READ_FUNC_CODE  0x03

ODR_Interface::ODR_Interface(uint8_t ID)
{
    this->ID = ID;
}

ODR_Interface::~ODR_Interface()
{
}
uint16_t ODR_Interface::get_msg_encode(uint8_t *msg, uint16_t add){
    uint16_t len = 0;
    msg[len++] = this -> ID;
    msg[len++] = READ_FUNC_CODE;
    msg[len++] = ((uint16_t)add >> 8) & 0xFF;
    msg[len++] = (uint16_t)add & 0xFF;
    msg[len++] = 0x00;
    msg[len++] = 0x01;
    uint16_t _crc = crc_modbus((uint8_t *) msg,len);
    msg[len++] = _crc & 0xFF;
    msg[len++] = (_crc >> 8) & 0xFF;
    return len;
}

void ODR_Interface::setValue(uint16_t add, const int &value){
    if (add < MIN_ADD || add >= MAX_ADD)
    {
        DebugError("ERROR: Address %u out of range %d - %d!",add ,MIN_ADD,MAX_ADD);
        return;
    }
    float r_value = value;

    if (add == TEMP || add == HUMI || add == NOISE || add == ATM)
    {
        r_value /= 10;
    }
    DebugInfo("Set [%s] : %.2f",name_value[add-MIN_ADD] ,r_value);
    pthread_mutex_lock(&_lock);
    _value[add-MIN_ADD] = r_value;
    pthread_mutex_unlock(&_lock);
}

float ODR_Interface::getValue(uint16_t add){
    if (add < MIN_ADD || add >= MAX_ADD)
    {
        DebugError("ERROR: Address %u out of range %d - %d!",add ,MIN_ADD,MAX_ADD);
        return INT32_MIN;
    }
    pthread_mutex_lock(&_lock);
    float return_value = _value[add-MIN_ADD];
    pthread_mutex_unlock(&_lock);
    return return_value;
}
