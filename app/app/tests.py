"""
Sample tests
"""

from django.test import SimpleTestCase

from app import calc


class CalcTests(SimpleTestCase):
    """tests"""

    def test_add_numbers(self):
        """Test adding numbers"""

        res = calc.add(5, 6)

        self.assertEqual(res, 11)

    def test_subtract_numbers(self):
        """Test subtracking"""
        res = calc.subtract(10, 15)

        self.assertEqual(res, 5)

    def test_multiply_numbers(self):
        res = calc.multiply(3,6)
        self.assertEqual(res, 18)
        res2 = calc.multiply(0,8)
        self.assertEqual(res2, 0)
        res3 = calc.multiply(1, 34)
        self.assertEqual(res3, 34)

