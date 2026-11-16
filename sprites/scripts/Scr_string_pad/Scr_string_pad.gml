function string_pad(_value, _digits)
{
    var _text = string(_value);

    while (string_length(_text) < _digits)
    {
        _text = "0" + _text;
    }

    return _text;
}