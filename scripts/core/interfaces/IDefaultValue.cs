namespace Core.Interfaces
{

	public interface IDefaultValue<T> where T : struct
	{
		/// <summary>
		/// Значение по умолчанию.
		/// </summary>
		public abstract T Default { get; set; }

		/// <summary>
		/// Текущее значение.
		/// </summary>
		public T Current { get; set; }
	}

}
